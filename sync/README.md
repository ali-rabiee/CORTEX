# CORTEX sync

A single-user, end-to-end-encrypted sync backend for CORTEX: a Cloudflare
Worker in front of a one-row D1 database. It exists so your laptop and your
phone can share one set of review cards, streaks, and XP.

It stays inside Cloudflare's free tier by a wide margin — an open tab syncs
roughly 700 times a day against limits of 100,000 Worker requests and 100,000
D1 writes.

## What it does and doesn't protect

The CORTEX web app is a **public static page**. Anyone with the URL can load it
and read the learning content — a passphrase prompt in a page served from
GitHub Pages is a curtain, not a lock, because the HTML and JavaScript are
downloadable regardless.

What is genuinely protected is **your progress data**:

- Every request needs a bearer token derived from your passphrase. Without it
  the Worker answers `401` and nothing else.
- The snapshot in D1 is AES-256-GCM ciphertext, encrypted in your browser. The
  Worker, D1, and Cloudflare see an opaque base64 string.
- The Worker stores only `SHA-256(token)`. Someone who reads the secret out of
  your Cloudflare account still cannot authenticate, and cannot derive the
  encryption key — it comes from a separate HKDF branch of the same passphrase.

```
passphrase ──PBKDF2(210k, SHA-256)──▶ master ──┬─HKDF "auth"─▶ bearer token ──SHA-256──▶ Worker secret
                                               └─HKDF "enc" ──▶ AES-GCM key  (never leaves the browser)
```

**There is no password reset.** Lose the passphrase and the synced snapshot is
unrecoverable. Keep exporting backups from Settings.

## Setup

From a clone of this repo, with Node 20+ installed:

```bash
cd sync
npm install
npm run setup
```

The script logs you into Cloudflare (opens a browser once), creates the D1
database, applies the schema, prompts for your passphrase, stores its digest as
a Worker secret, deploys, and prints your endpoint URL:

```
https://cortex-sync.<your-subdomain>.workers.dev
```

Then in CORTEX → **Settings → Sync across devices**: paste that URL, press
**Connect**, and unlock with the passphrase. Do the same on every other device.

It is safe to re-run `npm run setup` — each step is skipped if already done.

### Changing your passphrase

```bash
npm run rotate     # prompts, then replaces the Worker secret
```

Then unlock each device with the new passphrase. Because the encryption key
changes too, push from a device that already holds your progress first: it
re-encrypts the whole snapshot under the new key.

### Restricting which origins may call it

`ALLOWED_ORIGIN` in `wrangler.toml` defaults to `*`, which is safe — the bearer
token, not the origin, is what grants access. To narrow it anyway:

```toml
[vars]
ALLOWED_ORIGIN = "https://<you>.github.io"
```

then `npm run deploy`.

## API

All endpoints except `/health` require `Authorization: Bearer <token>`.

| Method   | Path      | Body                                | Response |
| -------- | --------- | ----------------------------------- | -------- |
| `GET`    | `/health` | —                                   | `{ok:true}` — unauthenticated liveness probe |
| `GET`    | `/state`  | —                                   | `{version, updatedAt, device, blob}`; `version: 0, blob: null` when empty |
| `PUT`    | `/state`  | `{baseVersion, blob, device}`       | `200` with the new state, or `409` with the current state if `baseVersion` is stale |
| `PUT`    | `/state?force=1` | `{blob, device}`             | Overwrites unconditionally (conflict resolution) |
| `DELETE` | `/state`  | —                                   | Wipes the stored snapshot |

Concurrency is optimistic. Clients send the `version` they last reconciled
with; a mismatch returns `409` rather than overwriting, and the app asks you
which side to keep. Nothing is resolved by timestamp, so a session is never
silently discarded.

## Files

```
sync/
├── src/index.ts       # the Worker
├── schema.sql         # one-row D1 table
├── wrangler.toml      # config; setup.sh fills in database_id
├── derive-token.mjs   # passphrase → Worker secret (mirrors the browser's crypto)
└── setup.sh           # provisioning
```

`derive-token.mjs` and `web/src/lib/sync/crypto.ts` implement the same
derivation twice. `web/src/lib/sync/__tests__/crypto.test.ts` pins both to a
shared test vector, so `npm test` in `web/` fails loudly if they ever drift —
which would otherwise lock every device out at once.
