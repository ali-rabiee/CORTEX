/** Thin HTTP client for the CORTEX sync Worker. */

export type RemoteState = {
  version: number;
  updatedAt: string | null;
  device: string | null;
  blob: string | null;
};

export type SyncErrorKind =
  | "unauthorized"
  | "network"
  | "server"
  | "too_large"
  | "bad_response";

export class SyncError extends Error {
  readonly kind: SyncErrorKind;

  constructor(kind: SyncErrorKind, message: string) {
    super(message);
    this.name = "SyncError";
    this.kind = kind;
  }
}

const MESSAGES: Record<SyncErrorKind, string> = {
  unauthorized: "Wrong passphrase for this sync endpoint.",
  network: "Couldn't reach the sync server.",
  server: "The sync server returned an error.",
  too_large: "Your progress is too large to sync.",
  bad_response: "The sync server sent something unexpected.",
};

function parseState(value: unknown): RemoteState {
  if (typeof value !== "object" || value === null) {
    throw new SyncError("bad_response", MESSAGES.bad_response);
  }
  const raw = value as Record<string, unknown>;
  if (typeof raw.version !== "number") {
    throw new SyncError("bad_response", MESSAGES.bad_response);
  }
  return {
    version: raw.version,
    updatedAt: typeof raw.updatedAt === "string" ? raw.updatedAt : null,
    device: typeof raw.device === "string" ? raw.device : null,
    blob: typeof raw.blob === "string" ? raw.blob : null,
  };
}

async function request(
  url: string,
  token: string,
  init: RequestInit = {},
): Promise<Response> {
  let response: Response;
  try {
    response = await fetch(url, {
      ...init,
      headers: {
        ...init.headers,
        Authorization: `Bearer ${token}`,
      },
      // Sync is small and correctness-critical; never serve it from an HTTP cache.
      cache: "no-store",
    });
  } catch {
    throw new SyncError("network", MESSAGES.network);
  }

  if (response.status === 401 || response.status === 403) {
    throw new SyncError("unauthorized", MESSAGES.unauthorized);
  }
  if (response.status === 413) {
    throw new SyncError("too_large", MESSAGES.too_large);
  }
  return response;
}

export async function fetchState(
  endpoint: string,
  token: string,
): Promise<RemoteState> {
  const response = await request(`${endpoint}/state`, token);
  if (!response.ok) throw new SyncError("server", `${MESSAGES.server} (${response.status})`);
  return parseState(await response.json());
}

export type PushResult =
  | { ok: true; state: RemoteState }
  | { ok: false; conflict: RemoteState };

export async function pushState(
  endpoint: string,
  token: string,
  payload: {
    baseVersion: number;
    blob: string;
    device: string;
    force?: boolean;
  },
): Promise<PushResult> {
  const url = `${endpoint}/state${payload.force ? "?force=1" : ""}`;
  const response = await request(url, token, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      baseVersion: payload.baseVersion,
      blob: payload.blob,
      device: payload.device,
    }),
  });

  if (response.status === 409) {
    return { ok: false, conflict: parseState(await response.json()) };
  }
  if (!response.ok) {
    throw new SyncError("server", `${MESSAGES.server} (${response.status})`);
  }
  return { ok: true, state: parseState(await response.json()) };
}

/** Unauthenticated liveness probe, used by the Settings "Test" button. */
export async function checkHealth(endpoint: string): Promise<boolean> {
  try {
    const response = await fetch(`${endpoint}/health`, { cache: "no-store" });
    return response.ok;
  } catch {
    return false;
  }
}
