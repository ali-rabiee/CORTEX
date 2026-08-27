#!/usr/bin/env bash
#
# One-shot provisioning for the CORTEX sync Worker.
#
#   ./setup.sh
#
# Creates the D1 database, applies the schema, stores the hash of your
# passphrase as a Worker secret, and deploys. Safe to re-run — each step is
# skipped if it's already done.

set -euo pipefail

cd "$(dirname "$0")"

DB_NAME="cortex-sync"
WRANGLER="npx --yes wrangler"

say()  { printf '\n\033[1;35m▸ %s\033[0m\n' "$*"; }
note() { printf '  %s\n' "$*"; }
die()  { printf '\n\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

command -v node >/dev/null || die "node not found — install Node 20 or newer."

# ------------------------------------------------------------------- login
#
# `wrangler whoami` exits 0 whether or not you are logged in, so the exit code
# tells us nothing — we have to read what it actually said.
logged_out() {
  printf '%s' "$1" | grep -qiE 'not authenticated|please run .?wrangler login'
}

say "Checking your Cloudflare login"
if [ -n "${CLOUDFLARE_API_TOKEN:-}" ]; then
  note "Using CLOUDFLARE_API_TOKEN from your environment."
else
  WHOAMI="$($WRANGLER whoami 2>&1 || true)"

  if logged_out "$WHOAMI"; then
    cat <<'EOF'
  You're not logged in yet. Wrangler will open your browser so you can
  authorise it against your Cloudflare account (free tier is fine).

  No browser here — SSH, container, headless box? Press Ctrl-C and run:

      npx wrangler login --device

  then start ./setup.sh again.

EOF
    $WRANGLER login
    WHOAMI="$($WRANGLER whoami 2>&1 || true)"
    logged_out "$WHOAMI" && die "Login didn't complete. Try 'npx wrangler login --device', or set CLOUDFLARE_API_TOKEN."
  fi

  printf '%s\n' "$WHOAMI" | grep -viE '^\s*$|^─+$|⛅️' | head -8
fi

# ---------------------------------------------------------------- database
lookup_db_id() {
  $WRANGLER d1 list --json 2>/dev/null | node -e '
    let raw = "";
    process.stdin.on("data", (c) => (raw += c));
    process.stdin.on("end", () => {
      // Wrangler prints a banner before the JSON payload.
      const start = raw.indexOf("[");
      if (start < 0) process.exit(1);
      let list;
      try { list = JSON.parse(raw.slice(start)); } catch { process.exit(1); }
      const hit = list.find((d) => d.name === process.argv[1]);
      if (!hit) process.exit(1);
      console.log(hit.uuid ?? hit.database_id ?? "");
    });
  ' "$DB_NAME" || true
}

if grep -q 'REPLACE_WITH_DATABASE_ID' wrangler.toml; then
  say "Creating the D1 database ($DB_NAME)"
  CREATE_LOG="$(mktemp)"
  trap 'rm -f "$CREATE_LOG"' EXIT
  $WRANGLER d1 create "$DB_NAME" 2>&1 | tee "$CREATE_LOG" || true

  DB_ID="$(grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' "$CREATE_LOG" | head -1 || true)"

  if [ -z "$DB_ID" ]; then
    if grep -qi 'already exists' "$CREATE_LOG"; then
      say "A database named $DB_NAME already exists — reusing it"
    else
      say "Create didn't return an id — checking whether the database exists anyway"
    fi
    DB_ID="$(lookup_db_id)"
  fi

  [ -n "$DB_ID" ] || die "Could not create or find the '$DB_NAME' database (see the error above).
  If it's a login problem, run 'npx wrangler login' and rerun ./setup.sh.
  Otherwise run 'npx wrangler d1 list', copy the id, and paste it over
  REPLACE_WITH_DATABASE_ID in sync/wrangler.toml."

  node -e '
    const fs = require("fs");
    const file = "wrangler.toml";
    fs.writeFileSync(
      file,
      fs.readFileSync(file, "utf8").replace("REPLACE_WITH_DATABASE_ID", process.argv[1]),
    );
  ' "$DB_ID"
  note "wrangler.toml now points at database $DB_ID"
else
  say "Database already configured in wrangler.toml — skipping creation"
fi

say "Applying the schema"
$WRANGLER d1 execute "$DB_NAME" --remote --file=schema.sql --yes

# ------------------------------------------------------------------ secret
say "Setting your passphrase"
cat <<'EOF'
  Choose a passphrase you'll type on every device. It is never transmitted:
  it's stretched locally, and only a hash of the derived token reaches
  Cloudflare. There is no reset — if you lose it, the synced data is gone.

  A memorable four- or five-word phrase beats a short complex one.

EOF
DIGEST="$(node derive-token.mjs)"
[ -n "$DIGEST" ] || die "No passphrase captured — nothing was changed."
printf '%s' "$DIGEST" | $WRANGLER secret put SYNC_TOKEN_SHA256

# ------------------------------------------------------------------ deploy
say "Deploying the Worker"
DEPLOY_LOG="$(mktemp)"
$WRANGLER deploy 2>&1 | tee "$DEPLOY_LOG"
URL="$(grep -oE 'https://[a-z0-9._-]+\.workers\.dev' "$DEPLOY_LOG" | head -1 || true)"
rm -f "$DEPLOY_LOG"

say "Done"
if [ -n "$URL" ]; then
  echo "  Your sync endpoint:"
  echo
  echo "      $URL"
  echo
  echo "  Open CORTEX → Settings → Sync across devices, paste that URL, press"
  echo "  Connect, then unlock with the passphrase you just chose. Repeat on"
  echo "  every other device with the same URL and passphrase."
  if command -v curl >/dev/null; then
    echo
    printf '  Health check: '
    curl -fsS "$URL/health" || printf '(no response yet — it can take a few seconds)'
    echo
  fi
else
  echo "  Deployed. Find the URL in the output above, ending in .workers.dev."
fi
