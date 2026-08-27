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
say() { printf '\n\033[1;35m▸ %s\033[0m\n' "$*"; }
die() { printf '\n\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

command -v node >/dev/null || die "node not found — install Node 20 or newer."

say "Checking your Cloudflare login"
if ! npx --yes wrangler whoami >/dev/null 2>&1; then
  echo "Not logged in. A browser window will open to authorise wrangler."
  npx --yes wrangler login
fi
npx --yes wrangler whoami

# ---------------------------------------------------------------- database
if grep -q 'REPLACE_WITH_DATABASE_ID' wrangler.toml; then
  say "Creating the D1 database ($DB_NAME)"
  CREATE_OUTPUT="$(npx --yes wrangler d1 create "$DB_NAME" 2>&1 || true)"
  echo "$CREATE_OUTPUT"

  DB_ID="$(printf '%s' "$CREATE_OUTPUT" \
    | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' \
    | head -1 || true)"

  # Already existed from an earlier run? Look it up instead.
  if [ -z "$DB_ID" ]; then
    say "Database already exists — looking up its id"
    DB_ID="$(npx --yes wrangler d1 list --json 2>/dev/null \
      | node -e '
          let raw = "";
          process.stdin.on("data", (c) => (raw += c));
          process.stdin.on("end", () => {
            const start = raw.indexOf("[");
            if (start < 0) process.exit(1);
            const list = JSON.parse(raw.slice(start));
            const hit = list.find((d) => d.name === process.argv[1]);
            if (!hit) process.exit(1);
            console.log(hit.uuid ?? hit.database_id ?? "");
          });
        ' "$DB_NAME" || true)"
  fi

  [ -n "$DB_ID" ] || die "Could not determine the database id. Run 'npx wrangler d1 list' and paste it into wrangler.toml manually."

  # BSD/GNU-portable in-place edit.
  node -e '
    const fs = require("fs");
    const file = "wrangler.toml";
    fs.writeFileSync(
      file,
      fs.readFileSync(file, "utf8").replace("REPLACE_WITH_DATABASE_ID", process.argv[1]),
    );
  ' "$DB_ID"
  echo "wrangler.toml now points at database $DB_ID"
else
  say "Database already configured in wrangler.toml — skipping creation"
fi

say "Applying the schema"
npx --yes wrangler d1 execute "$DB_NAME" --remote --file=schema.sql --yes

# ------------------------------------------------------------------ secret
say "Setting your passphrase"
cat <<'EOF'
Choose a passphrase you'll type on every device. It is never transmitted:
it's stretched locally, and only a hash of the derived token is stored on
Cloudflare. There is no reset — if you lose it, the synced data is gone.

A memorable four- or five-word phrase beats a short complex one.
EOF
echo
DIGEST="$(node derive-token.mjs)"
printf '%s' "$DIGEST" | npx --yes wrangler secret put SYNC_TOKEN_SHA256

# ------------------------------------------------------------------ deploy
say "Deploying the Worker"
DEPLOY_OUTPUT="$(npx --yes wrangler deploy 2>&1)"
echo "$DEPLOY_OUTPUT"

URL="$(printf '%s' "$DEPLOY_OUTPUT" | grep -oE 'https://[a-z0-9.-]+\.workers\.dev' | head -1 || true)"

say "Done"
if [ -n "$URL" ]; then
  echo "Your sync endpoint:"
  echo
  echo "    $URL"
  echo
  echo "Open CORTEX → Settings → Sync across devices, paste that URL, hit"
  echo "Connect, then unlock with the passphrase you just chose. Repeat on"
  echo "every other device with the same URL and passphrase."
  if command -v curl >/dev/null; then
    echo
    echo -n "Health check: "
    curl -fsS "$URL/health" || echo "(no response yet — it can take a few seconds)"
    echo
  fi
else
  echo "Deployed. Find the URL in the output above, ending in .workers.dev."
fi
