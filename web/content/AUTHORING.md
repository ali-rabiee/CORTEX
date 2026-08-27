# CORTEX content authoring guide

The single reference for writing concept content. If you are an agent picking
this up in a fresh session, read this file top to bottom before writing
anything — it is the contract.

**Reference implementation:** `content/concepts/robot_learning/behavior_cloning/`.
When this guide and that folder disagree, the folder wins.

---

## 1. The goal

The reader is a PhD-level robotics/ML researcher preparing for **research
scientist interviews** in robot learning, RL, and ML. Every concept must take
them along one arc:

> **understand it → learn the details → be able to say it out loud in an interview**

Content that only *states* facts has failed, however accurate. The seed files
(auto-migrated from the old Flutter app) restate their own `keyPoints` as prose;
that is exactly what we are replacing.

---

## 2. Anatomy of a concept

```
content/concepts/<domain>/<concept_id>/
├── meta.yaml            # id, title, domain, summary, tags, difficulty, importance, related
├── l1-intuition.mdx     # Understand
├── l2-math.mdx          # The details
├── l3-code.mdx          # In code
├── l4-frontier.mdx      # Frontier
└── l5-application.mdx   # Say it in an interview
```

All five render as **one scrolling page** with a sticky section rail. They are
not gated tabs — the reader can jump straight to the interview answer. Write
each part so it stands alone but flows from the previous one.

| File | Heading | What it must do |
| --- | --- | --- |
| `l1-intuition` | Understand | Plain language, an analogy, a **diagram**, numbered steps, curated video links. No jargon before it is earned. |
| `l2-math` | The details | Formal definitions and a real **derivation**, built up in steps. Name the assumption doing the work. |
| `l3-code` | In code | Minimal runnable PyTorch. Annotate the 2–3 lines that matter; the rest is boilerplate. |
| `l4-frontier` | Frontier | The papers, as a narrative arc — what each one changed and why the field moved on. |
| `l5-application` | Say it in an interview | Failure-mode triage plus the `interview` block: the spoken answer, follow-ups, traps. |

---

## 3. Frontmatter

Validated by `src/lib/content/schema.ts` (`levelFrontmatterSchema`). The build
fails on anything that does not parse.

```yaml
---
concept: behavior_cloning     # MUST equal the directory name
level: 1                      # MUST equal the l<N>- filename prefix
status: final                 # seed | draft | final

recall:                       # what a spaced-repetition review shows
  prompt: "Explain X in plain language. What is the one thing that goes wrong?"
  keyPoints:
    - "Self-contained claims. These are the rubric you grade yourself against."

media:                        # rendered by <WatchThis />
  - kind: lecture             # video | lecture | article | interactive
    title: "CS 285 Lecture 2: Imitation Learning, Part 1"
    url: https://www.youtube.com/watch?v=tbLaFtYpWWU
    source: "UC Berkeley CS285 · Sergey Levine"
    minutes: 17
    note: "What to look for, or which timestamps are worth it."

check:                        # level-up gate, pass at 80%
  - id: bc_l1_c1              # <concept-abbrev>_l<N>_c<i>, globally unique
    prompt: "..."
    options: ["...", "...", "...", "..."]
    answer: 1                 # 0-based index
    explanation: "Why the right answer is right AND why the tempting one is wrong."

interview:                    # L5 ONLY — required there
  answer: >-
    45–90 seconds, first person, written the way you would actually say it.
  followUps:
    - q: "The question they ask next"
      a: "How to handle it."
  traps:
    - "The wrong turn that costs people this question."

papers:                       # L4 mainly; rendered via <PaperCard refKey="..." />
  - key: ross2011dagger
    title: "A Reduction of Imitation Learning ... to No-Regret Online Learning"
    authors: "Stéphane Ross, Geoffrey J. Gordon, J. Andrew Bagnell"
    venue: AISTATS
    year: 2011
    arxiv: "1011.0686"
    takeaway: "One sentence: what this paper changed."
---
```

---

## 4. Components

| Component | Use for |
| --- | --- |
| `<Intuition>` | The plain-language framing. Usually one per L1. |
| `<KeyIdea>` | The one thing to remember from a section. |
| `<Warning>` | Sharp edges, common misreadings, things interviewers probe. |
| `<Steps>` / `<Step title="…">` | Any *sequence* — how it runs, how to diagnose, how a derivation proceeds. |
| `<Figure src alt caption />` | A diagram from `public/figures/`. SVG only. |
| `<Derivation title="…">` | A collapsible derivation. Show every step. |
| `<CodeWalk title="…">` | An annotated code block. |
| `<WatchThis />` | Renders `media`. Place at the end of L1. |
| `<InterviewAnswer />` | Renders `interview`. Place near the end of L5. |
| `<PaperCard refKey="…" />` / `<PaperGrid>` | Renders entries from `papers`. |

---

## 5. The `final` quality bar

`npm run validate` enforces these. Do not set `status: final` until they hold.

- **≥ 2 check questions** per level, with distractors that encode real
  misconceptions — not obviously-wrong filler.
- **L1 needs `media`** and either `<Steps>` or `<Figure>`. It must *show*, not tell.
- **L5 must have an `interview` block.** This is an error, not a warning.
- Declared `media` / `interview` must actually be rendered by their component.
- **L4 needs `papers`.**

Beyond what the linter can see:

- **Never restate `keyPoints` as the body.** That is the seed-file failure mode.
- Every `<Derivation>` names the assumption doing the work.
- Prose is direct and specific. No "it is important to note that".
- Body length ≈ 4–7 KB per level. Under 2 KB means you are still stubbing.

---

## 6. Verifying references — non-negotiable

**Never write a citation or URL from memory.** Fabricated references are worse
than none: they get repeated in a room with someone who has read the paper.

```bash
# arXiv: confirm id -> title, authors, year
curl -sS "https://export.arxiv.org/api/query?id_list=1011.0686,2304.13705&max_results=20"

# Any URL: confirm it resolves
curl -sS -o /dev/null -L -A "Mozilla/5.0" -w "%{http_code}\n" <url>

# YouTube: confirm the video is what you think it is
curl -sS -L -A "Mozilla/5.0" "<url>" | grep -oE '<title>[^<]*</title>'
```

If a link cannot be verified, leave it out. Known-good sources so far:

| URL | What it is |
| --- | --- |
| `https://www.youtube.com/watch?v=tbLaFtYpWWU` | CS 285 Lecture 2, Imitation Learning Part 1 |
| `https://tonyzhaozh.github.io/aloha/` | ALOHA / ACT project page |
| `https://diffusion-policy.cs.columbia.edu/` | Diffusion Policy project page |
| `https://umi-gripper.github.io/` | UMI project page |
| `https://lilianweng.github.io/posts/2021-07-11-diffusion-models/` | Lilian Weng, diffusion models |

---

## 7. Figures

SVG in `public/figures/<concept>-<what>.svg`, referenced as
`<Figure src="/figures/…" />` (the component adds the base path).

- viewBox `0 0 640 300`, `font-family="system-ui, …"`.
- Dark palette: bg `#0d1117`, surface `#1c2128`, border `#30363d`,
  text `#e6edf3`, muted `#8b949e`, faint `#484f58`,
  accent `#6c63ff`, good `#3fb950`, bad `#f85149`.
- Include `<title>` and `<desc>` for screen readers.
- Draw the *mechanism*, not decoration. Good ones so far:
  `bc-compounding-error` (drift widening), `dagger-loop` (the cycle),
  `mode-averaging` (mean vs. modes).
- Validate: `python3 -c "import xml.dom.minidom;xml.dom.minidom.parse('public/figures/x.svg')"`

---

## 8. MDX gotchas

- Escape stray `{`, `}`, `<` in prose — they are JSX. Use `\{`.
- Never `\$` inside math; use `\textdollar`.
- In YAML double-quoted strings LaTeX backslashes must be doubled: `"$\\gamma$"`.
  Folded scalars (`>-`) keep single backslashes — prefer them for prose.
- `<` in prose (e.g. "k < 10") breaks the parse. Write `$k < 10$` or "less than".

---

## 9. Workflow

```bash
cd web
npm run status              # what's done, what's next (--all for low-importance)
# ... author the five files ...
npm run validate            # schema + the final quality bar
npm run build               # compiles MDX; fails loudly on JSX/LaTeX errors
npm test && npm run e2e     # only needed if you touched src/
git add -A web && git commit && git push
```

Work in **clusters** that cross-reference each other, not alphabetically — a
cluster reinforces itself and lets you reuse verified references.

---

## 10. Priority order

Target the ~30 concepts that actually appear in robot-learning / RL research
scientist interviews, not all 89.

| # | Cluster | Concepts | Notes |
| --- | --- | --- | --- |
| ✅ 1 | Imitation core | `behavior_cloning`, `dagger`, `imitation_learning`, `action_chunking` | Done |
| 2 | Imitation cont. | `diffusion_policy`, `visuomotor_policy`, `multi_task_policy` | |
| 3 | RL core | `mdp`, `bellman_equations`, `policy_gradients`, `ppo_clipping`, `sac`, `gae`, `dqn`, `offline_rl` | **Cheapest** — L3/L4 already final, only L1/L2/L5 needed |
| 4 | RL cont. | `value_functions`, `advantage_estimation`, `exploration`, `trpo`, `td3` | |
| 5 | Sim2real | `sim2real_transfer`, `domain_randomization`, `sim_to_real_pipeline`, `sim_environments` | |
| 6 | VLA / FM | `vla_models`, `rt2_robotic_fm`, `action_tokenization`, `transformer_attention` | |
| 7 | Systems | `evaluation_methodology`, `dataset_curation`, `deployment_thinking`, `safety_monitoring` | High interview value, often neglected |

**Missing concepts worth creating** (referenced as `related_concept_ids` but do
not exist): `covariate_shift`, `inverse_rl`, `gail`. Also absent and important
for these roles: model-based RL (Dreamer/MuZero), RLHF/DPO, locomotion.

---

## 11. Prompt for a fresh session

Paste this into a new session to continue with no other context:

```
Continue authoring CORTEX concept content.

Read web/content/AUTHORING.md first — it is the full spec, and
web/content/concepts/robot_learning/behavior_cloning/ is the reference
implementation to match for depth, tone, and structure.

Then run `cd web && npm run status` to see what is done and what is next.

Author the next cluster from the priority table in section 10 — all five level
files per concept, status: final, meeting the quality bar in section 5.

Rules:
- Verify EVERY citation and URL before writing it (section 6). Never write a
  reference from memory.
- Run `npm run validate` and `npm run build` before committing; both must pass.
- Commit and push each concept cluster separately.
- Tell me which concepts you completed and what the status counts are now.

Work through as many concepts as you can. Depth over coverage — a shallow file
is worse than no file, because it looks done.
```
