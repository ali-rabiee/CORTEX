# CORTEX

Daily cognitive training for robotics / ML researchers. It turns PhD-level
concepts — RL, robot learning, perception, foundation models, generative
control, systems — into a spaced-repetition curriculum, where each of 89
concepts has five mastery levels (intuition → math → code → frontier papers →
application) and passing a level's check unlocks the next.

**Live at <https://ali-rabiee.github.io/CORTEX/>** — installable on a phone,
works offline, and syncs across devices end-to-end encrypted.

```
web/     Next.js 15 web app — the active implementation
sync/    Cloudflare Worker + D1 — optional encrypted cross-device sync
app/     Flutter desktop app — legacy, kept for reference
backend/ optional FastAPI service (unused by the web app)
```

## Web app

```bash
cd web
npm install
npm run dev              # http://localhost:3000
npm run build            # validate content + static export to out/
npm test                 # engine + persistence unit tests
npm run e2e              # Playwright against the static export
```

Requires Node 20+. See [`web/README.md`](web/README.md) for the content
authoring format, the level model, and the MDX gotchas.

### Publishing to GitHub Pages

Pushing to `main` runs [`.github/workflows/deploy-web.yml`](.github/workflows/deploy-web.yml),
which tests, builds with `NEXT_BASE_PATH=/CORTEX`, and deploys `web/out`.

One-time repo setup: **Settings → Pages → Build and deployment → Source:
GitHub Actions**. Then push, or trigger **Actions → Deploy web app to GitHub
Pages → Run workflow**.

Under a different repo name, change `NEXT_BASE_PATH` in the workflow to match.
At a domain root, remove it.

### On your phone

Open the URL, then **Share → Add to Home Screen** (iOS) or **Install app**
(Android). It launches standalone, without browser chrome, and a service worker
keeps it usable offline.

## Sync

Progress lives in the browser's IndexedDB. That is the whole story until you
point the app at a sync Worker of your own:

```bash
cd sync
npm install
npm run setup       # creates D1, stores your passphrase hash, deploys
```

Paste the printed URL into **Settings → Sync across devices**, unlock with your
passphrase, and repeat on every other device.

Your passphrase is stretched with PBKDF2 and split into two independent keys:
one authenticates to the Worker, one encrypts the snapshot in your browser. The
Worker stores ciphertext plus a hash of the auth token — not the passphrase,
and not anything that can decrypt your data.

**The published page itself is public.** Anyone with the URL can load the app
and read the learning content; a passphrase prompt in a static page cannot
change that. What the passphrase protects is your progress data. Details and
threat model in [`sync/README.md`](sync/README.md).

There is no password reset. Export a backup from Settings now and then.

## Flutter app (legacy)

The original Linux desktop implementation. Its engine logic and content were
ported to `web/`; it is kept for reference and not actively developed.

```bash
./run.sh              # debug run with hot reload
./run.sh release      # build and run release binary
cd app && flutter test
```

`run.sh` forces Mesa GL and integer GDK scaling to dodge the `FL_IS_COMPOSITOR`
crash on hybrid Intel + NVIDIA GPUs with 4K displays.

First-time setup:

```bash
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
flutter config --enable-linux-desktop
flutter doctor                                    # must pass
cd app && flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Rerun `build_runner` after any Drift table or Freezed entity change.
