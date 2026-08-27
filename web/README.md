# CORTEX Web

Local-first web app for daily robotics/ML cognitive training. Static-exported
Next.js, installable as a PWA on phones. Progress lives in your browser's
IndexedDB, with JSON export/import for backup and optional end-to-end-encrypted
sync across devices (see `../sync/`).

## The learning model

Every concept has **5 mastery levels**, each a separate MDX document:

| Level | Name        | What it teaches                                      |
| ----- | ----------- | ---------------------------------------------------- |
| L1    | Intuition   | Plain-language explanation + real robotics examples  |
| L2    | Math        | Formal definitions, clean LaTeX, derivations         |
| L3    | Code        | Minimal runnable Python/PyTorch implementations      |
| L4    | Frontier    | Seminal + 2023–2026 papers with arXiv links          |
| L5    | Application | Failure modes, debugging, interview-grade answers    |

Passing a level's check (≥80%) unlocks the next, grants XP, and creates/updates
an SM-2 spaced-repetition card targeted at your current level. Daily sessions
(warmup → core reviews → challenge quiz) keep concepts from decaying;
confidence calibration shortens intervals when you're overconfident.

## Commands

```bash
npm run dev              # dev server (content hot-reloads)
npm run build            # validate content + static export to out/
npm test                 # engine + persistence unit tests (vitest)
npm run e2e              # Playwright against out/ (build first)
npm run validate         # content integrity checks only
npm run migrate-content  # regenerate content/ from the Flutter app's JSONs (one-time)
node scripts/screenshot.mjs  # visual smoke-shots to /tmp/cortex-shots
```

Requires Node 20+ (Node 22 LTS recommended).

## Layout

```
web/
├── content/                  # All learning content (MDX/YAML) — the product
│   ├── concepts/<domain>/<id>/{meta.yaml, l1-intuition.mdx, … l5-application.mdx}
│   ├── quizzes/<domain>.yaml
│   └── curriculum/{worlds,chapters}.yaml
├── content-collections.ts    # Build-time MDX pipeline (Zod-validated frontmatter,
│                             #   remark-math + rehype-katex + rehype-pretty-code)
├── src/
│   ├── app/                  # Routes: / /learn /concepts/[id] /session /quiz /progress /settings
│   ├── components/           # UI (level tabs/rings/checks, session player, charts, MDX components)
│   ├── lib/engine/           # Pure logic ported from the Flutter app: SM-2, calibration,
│   │                         #   unlock gating, mastery, adaptive difficulty, sessions, XP, streaks
│   ├── lib/db/               # Dexie (IndexedDB) schema, repos, backup, local revision
│   ├── lib/sync/            # Passphrase crypto, sync client, reconcile engine, provider
│   └── lib/content/          # Content schemas + typed accessors + client manifest
├── e2e/                      # Playwright smoke suite (runs against the static export)
└── scripts/                  # migrate-content, validate-content, screenshot
```

## Authoring content

Each level file's frontmatter drives the app:

```yaml
---
concept: ppo_clipping
level: 3
status: final          # seed = auto-migrated, draft, final
recall:                # what a spaced-repetition review shows at this level
  prompt: "Sketch the PPO clipped loss in PyTorch."
  keyPoints: ["ratio = exp(logp_new - logp_old)", "clamp(ratio, 1±ε)", "take the min"]
check:                 # level-up gate (pass ≥80%)
  - id: ppo_l3_c1
    prompt: "Why `torch.min` of the two surrogate terms?"
    options: ["...", "..."]
    answer: 0
    explanation: "..."
papers:                # L4 levels: rendered as PaperCards via <PaperCard refKey="..."/>
  - key: schulman2017ppo
    title: "Proximal Policy Optimization Algorithms"
    year: 2017
    arxiv: "1707.06347"
    takeaway: "Clipping replaces TRPO's trust region with a first-order method."
---
```

Body is MDX: `$...$` / `$$...$$` math, fenced `python` blocks (Shiki-highlighted),
and components: `<Intuition>`, `<KeyIdea>`, `<Warning>`, `<Derivation>`,
`<CodeWalk>`, `<PaperCard>`, `<PaperGrid>`.

Gotchas:
- Never use `\$` inside math — micromark ends the span at the `$`. Use
  `\textdollar` (a provided KaTeX macro).
- Escape stray `{`, `}`, `<` in prose (`\{`) — they are JSX syntax in MDX.
  The build fails loudly if you miss one.

## Deploying

`.github/workflows/deploy-web.yml` deploys `web/out` to GitHub Pages on pushes
to `main` (enable Pages → GitHub Actions in repo settings). The workflow sets
`NEXT_BASE_PATH=/CORTEX` for the project-site URL prefix. Any static host
works: `npm run build && rsync out/ host:…`.

Live at <https://ali-rabiee.github.io/CORTEX/>.

If you fork this under a different repo name, change `NEXT_BASE_PATH` to match;
if you host it at a domain root, drop the variable entirely.

## Mobile

The layout is responsive by construction — sidebar at `md` and up, fixed bottom
nav below it, with `env(safe-area-inset-bottom)` padding so the nav clears the
iPhone home indicator. `viewportFit: "cover"` lets the background paint into the
notch.

`src/app/manifest.ts` plus `public/icons/` (regenerate with
`python3 scripts/generate-icons.py`) make it installable: **Share → Add to Home
Screen** on iOS, **Install app** on Android. It then opens standalone, without
browser chrome.

`public/sw.js` caches content-hashed `_next/static` assets cache-first and
everything else network-first, so the app opens offline but still picks up a new
deploy on the next online load.

## Sync

Sync is opt-in and off until you paste a Worker URL into Settings; without it the
app is purely local. Once configured:

- Your passphrase derives an auth token *and* a separate AES-GCM key. The server
  gets ciphertext and a hash of the token — never the passphrase or the key.
- `lib/db/db.ts` keeps a monotonic **local revision**, bumped by a Dexie
  middleware on every write, so the engine can tell "this device has unpushed
  work" from "nothing changed" without diffing the database.
- `lib/sync/engine.ts` reconciles: push when only this device moved, pull when
  only the server did, and **ask** when both did. Conflicts are never resolved by
  timestamp.
- Reconciles run on unlock, on tab focus, on regaining connectivity, every two
  minutes, and eight seconds after local writes settle.

See `../sync/README.md` for provisioning the Worker, and for what the passphrase
does and doesn't protect on a public static page.
