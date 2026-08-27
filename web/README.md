# CORTEX Web

Local-first web app for daily robotics/ML cognitive training. Static-exported
Next.js, installable as a PWA on phones. Progress lives in your browser's
IndexedDB, with JSON export/import for backup and optional end-to-end-encrypted
sync across devices (see `../sync/`).

## The learning model

Every concept has **5 mastery levels**, each a separate MDX document:

| Part | Heading               | What it teaches                                     |
| ---- | --------------------- | --------------------------------------------------- |
| L1   | Understand            | Plain language, an analogy, a diagram, numbered steps |
| L2   | The details           | Formal definitions and derivations, built up in steps |
| L3   | In code               | Minimal runnable Python/PyTorch implementations       |
| L4   | Frontier              | Seminal + 2023–2026 papers with arXiv links           |
| L5   | Say it in an interview| The spoken answer, follow-ups, and traps              |

All five parts render as **one scrolling page** with a sticky section rail —
they are not gated tabs. You frequently want the interview answer before you
have ground through the math, and locking it behind three checks made the page
hostile to how it actually gets used. Passing a check still records mastery,
grants XP, and drives spaced repetition; it just no longer withholds reading.

Passing a part's check (≥80%) grants XP and creates/updates an SM-2
spaced-repetition card targeted at your current level. Daily sessions
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
media:                 # curated external explanations; rendered by <WatchThis />
  - kind: lecture      # video | lecture | article | interactive
    title: "CS 285 Lecture 2: Imitation Learning, Part 1"
    url: https://www.youtube.com/watch?v=tbLaFtYpWWU
    source: "UC Berkeley CS285 · Sergey Levine"
    minutes: 17
    note: "Watch this one if you watch nothing else."
interview:             # L5 only; rendered by <InterviewAnswer />
  answer: >-
    The 45–90 second answer, written the way you would actually say it.
  followUps:
    - q: "So why not just always use DAgger?"
      a: "Because it needs an expert you can query online…"
  traps:
    - "Saying it fails 'because of overfitting'."
papers:                # L4 levels: rendered as PaperCards via <PaperCard refKey="..."/>
  - key: schulman2017ppo
    title: "Proximal Policy Optimization Algorithms"
    year: 2017
    arxiv: "1707.06347"
    takeaway: "Clipping replaces TRPO's trust region with a first-order method."
---
```

Body is MDX: `$...$` / `$$...$$` math, fenced `python` blocks (Shiki-highlighted),
and these components:

| Component | Use it for |
| --- | --- |
| `<Intuition>` `<KeyIdea>` `<Warning>` | Callouts — the framing, the one thing to remember, the sharp edge |
| `<Steps>` / `<Step title="…">` | A numbered walkthrough. Reach for this whenever the concept is really a *sequence* |
| `<Figure src alt caption />` | A diagram from `public/figures/` — SVG, so it stays crisp and tiny on a phone |
| `<Derivation title="…">` | A collapsible derivation |
| `<CodeWalk title="…">` | An annotated code block |
| `<WatchThis />` | Renders the level's `media` as link cards. Links, not embeds — embeds would break offline use |
| `<InterviewAnswer />` | Renders the level's `interview` block: the spoken answer, follow-ups, traps |
| `<PaperCard refKey="…" />` `<PaperGrid>` | Citations from the level's `papers` |

**[`content/AUTHORING.md`](content/AUTHORING.md) is the full spec** — frontmatter,
components, the enforced quality bar, reference-verification rules, figure
conventions, priority order, and a ready-to-paste prompt for continuing the work
in a fresh session. `content/concepts/robot_learning/behavior_cloning/` is the
worked reference implementation.

```bash
npm run status          # what's authored, what's next (--all for low-importance)
npm run validate        # schema + the `final` quality bar
```

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
