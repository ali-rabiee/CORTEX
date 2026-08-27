/**
 * CORTEX sync Worker.
 *
 * Stores exactly one encrypted snapshot of a single user's progress in D1 and
 * serves it back. Two properties matter:
 *
 *   1. Authentication — every request must carry the bearer token derived from
 *      the user's passphrase. The Worker only ever sees SHA-256 of that token
 *      (stored as the SYNC_TOKEN_SHA256 secret), so leaking the secret does not
 *      let anyone authenticate.
 *   2. Confidentiality — `blob` is AES-GCM ciphertext produced in the browser
 *      with a key derived from the same passphrase down a *different* HKDF
 *      path. This Worker, D1, and Cloudflare cannot read it.
 *
 * Concurrency is optimistic: clients send the version they last reconciled
 * with, and a mismatch returns 409 with the current state so the client can
 * resolve it rather than silently clobbering the other device.
 */

export interface Env {
  DB: D1Database;
  SYNC_TOKEN_SHA256: string;
  ALLOWED_ORIGIN?: string;
}

type StateRow = {
  version: number;
  updated_at: string;
  device: string | null;
  blob: string;
};

/** Ciphertext is base64; 4 MB of it is far beyond any realistic backup. */
const MAX_BODY_BYTES = 4 * 1024 * 1024;

function corsHeaders(env: Env, request: Request): Record<string, string> {
  const allowed = (env.ALLOWED_ORIGIN ?? "*").split(",").map((s) => s.trim());
  const origin = request.headers.get("Origin");
  const allowOrigin =
    allowed.includes("*") || !origin
      ? "*"
      : allowed.includes(origin)
        ? origin
        : "null";
  return {
    "Access-Control-Allow-Origin": allowOrigin,
    "Access-Control-Allow-Methods": "GET, PUT, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "Authorization, Content-Type",
    "Access-Control-Max-Age": "86400",
    Vary: "Origin",
  };
}

function json(
  body: unknown,
  status: number,
  headers: Record<string, string>,
): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...headers, "Content-Type": "application/json" },
  });
}

async function sha256Hex(input: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(input),
  );
  return [...new Uint8Array(digest)]
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/** Length-independent, content-constant-time string comparison. */
function timingSafeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

async function authorize(request: Request, env: Env): Promise<boolean> {
  const header = request.headers.get("Authorization") ?? "";
  const match = /^Bearer\s+(.+)$/i.exec(header.trim());
  if (!match) return false;
  const expected = (env.SYNC_TOKEN_SHA256 ?? "").trim().toLowerCase();
  if (!expected) return false;
  return timingSafeEqual(await sha256Hex(match[1].trim()), expected);
}

async function readState(env: Env): Promise<StateRow | null> {
  return env.DB.prepare(
    "SELECT version, updated_at, device, blob FROM state WHERE id = 1",
  ).first<StateRow>();
}

function stateResponse(
  row: StateRow | null,
  headers: Record<string, string>,
  status = 200,
): Response {
  return json(
    row
      ? {
          version: row.version,
          updatedAt: row.updated_at,
          device: row.device,
          blob: row.blob,
        }
      : { version: 0, updatedAt: null, device: null, blob: null },
    status,
    headers,
  );
}

async function handlePut(
  request: Request,
  env: Env,
  headers: Record<string, string>,
  force: boolean,
): Promise<Response> {
  const raw = await request.text();
  if (raw.length > MAX_BODY_BYTES) {
    return json({ error: "payload_too_large" }, 413, headers);
  }

  let body: { baseVersion?: unknown; blob?: unknown; device?: unknown };
  try {
    body = JSON.parse(raw);
  } catch {
    return json({ error: "invalid_json" }, 400, headers);
  }

  const blob = body.blob;
  if (typeof blob !== "string" || blob.length === 0) {
    return json({ error: "blob_required" }, 400, headers);
  }
  const device = typeof body.device === "string" ? body.device.slice(0, 64) : null;
  const now = new Date().toISOString();

  if (force) {
    await env.DB.prepare(
      `INSERT INTO state (id, version, updated_at, device, blob)
       VALUES (1, 1, ?1, ?2, ?3)
       ON CONFLICT(id) DO UPDATE SET
         version    = state.version + 1,
         updated_at = excluded.updated_at,
         device     = excluded.device,
         blob       = excluded.blob`,
    )
      .bind(now, device, blob)
      .run();
    return stateResponse(await readState(env), headers);
  }

  const baseVersion = body.baseVersion;
  if (typeof baseVersion !== "number" || !Number.isInteger(baseVersion) || baseVersion < 0) {
    return json({ error: "base_version_required" }, 400, headers);
  }

  // Applies only if the stored version still matches what the client last saw.
  // The `WHERE ?4 = 0` guard makes the insert path reject a client that thinks
  // it has a base version while the server is empty (i.e. the row was wiped).
  const result = await env.DB.prepare(
    `INSERT INTO state (id, version, updated_at, device, blob)
     SELECT 1, 1, ?1, ?2, ?3 WHERE ?4 = 0
     ON CONFLICT(id) DO UPDATE SET
       version    = state.version + 1,
       updated_at = excluded.updated_at,
       device     = excluded.device,
       blob       = excluded.blob
     WHERE state.version = ?4`,
  )
    .bind(now, device, blob, baseVersion)
    .run();

  if (!result.meta.changes) {
    return stateResponse(await readState(env), headers, 409);
  }
  return stateResponse(await readState(env), headers);
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const headers = corsHeaders(env, request);
    const url = new URL(request.url);

    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers });
    }

    // Unauthenticated liveness check — reveals nothing but "the Worker is up".
    if (url.pathname === "/health") {
      return json({ ok: true }, 200, headers);
    }

    if (url.pathname !== "/state") {
      return json({ error: "not_found" }, 404, headers);
    }

    if (!(await authorize(request, env))) {
      return json({ error: "unauthorized" }, 401, headers);
    }

    try {
      switch (request.method) {
        case "GET":
          return stateResponse(await readState(env), headers);
        case "PUT":
          return await handlePut(
            request,
            env,
            headers,
            url.searchParams.get("force") === "1",
          );
        case "DELETE":
          await env.DB.prepare("DELETE FROM state WHERE id = 1").run();
          return json({ version: 0, updatedAt: null, blob: null }, 200, headers);
        default:
          return json({ error: "method_not_allowed" }, 405, headers);
      }
    } catch (err) {
      return json(
        { error: "server_error", detail: err instanceof Error ? err.message : "unknown" },
        500,
        headers,
      );
    }
  },
} satisfies ExportedHandler<Env>;
