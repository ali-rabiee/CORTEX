# CORTEX — Daily Cognitive Training for Robotics/AI

Target user: PhD-level robotics/ML researcher preparing for industry.

Three pieces live in this repo:
- **`web/` — the active one.** Next.js 15 static-export web app with leveled concepts (L1 intuition → L2 math → L3 code → L4 papers → L5 application), SM-2 reviews, and progress in IndexedDB. Deployed to GitHub Pages at <https://ali-rabiee.github.io/CORTEX/>. See `web/README.md` for the content authoring format and gotchas.
- **`sync/` — the sync Worker.** Cloudflare Worker + D1 holding one end-to-end-encrypted snapshot of progress, so devices stay in step. Optional: the app is fully usable without it. See `sync/README.md`.
- **`app/` — legacy Flutter desktop app.** Kept as reference; its engine logic and content were ported to `web/`. Don't extend it unless asked.

## Commands (web — primary)

- `cd web && npm run dev` — dev server
- `cd web && npm run build` — validate content + static export to `web/out/`
- `cd web && npm test` — engine/persistence unit tests (vitest)
- `cd web && npm run e2e` — Playwright against the static export (build first)
- `cd web && npm run validate` — content integrity checks only
- Requires Node 20+ (Node 22 is symlinked in `~/.local/bin`; system apt node is 18/EOL — don't use it)

## Commands (sync Worker)

- `cd sync && npm run setup` — provision D1 + secret + deploy (idempotent)
- `cd sync && npm run deploy` — redeploy after editing `src/index.ts`
- `cd sync && npm run rotate` — change the passphrase
- `cd sync && npm run tail` — live Worker logs

## Commands (Flutter — legacy)

- `cd app && flutter run -d linux` — run desktop app
- `cd app && flutter test` — run all tests
- `cd app && flutter test test/<file>_test.dart` — run single test
- `cd app && flutter analyze` — static analysis
- `cd app && dart format .` — format Dart code
- `cd app && flutter build linux` — release build
- `conda activate cortex && cd backend && uvicorn main:app --reload` — run backend
- `conda activate cortex && cd backend && pytest` — run backend tests

## Architecture

```
cortex/
├── app/                        # Flutter application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── core/               # App config, theme, routing, DI
│   │   ├── data/               # Database (Drift), repositories, local data sources
│   │   ├── domain/             # Entities, use cases, repository interfaces
│   │   ├── presentation/       # Screens, widgets, state management (Riverpod)
│   │   │   ├── home/
│   │   │   ├── daily_session/
│   │   │   ├── concept_map/
│   │   │   ├── review_queue/
│   │   │   ├── quiz/
│   │   │   ├── failure_lab/
│   │   │   ├── interview/
│   │   │   ├── progress/
│   │   │   └── settings/
│   │   └── content/            # Seed data, concept definitions, quiz banks
│   ├── test/
│   └── pubspec.yaml
├── backend/                    # Python/FastAPI (optional, conda env)
│   ├── main.py
│   ├── routers/
│   ├── models/
│   ├── services/
│   └── tests/
├── content/                    # Shared concept data (JSON/YAML)
│   ├── concepts/
│   ├── quizzes/
│   ├── failure_scenarios/
│   └── interview_prompts/
├── docs/                       # Design docs, architecture decisions
├── scripts/                    # Setup, content generation, utilities
├── environment.yml             # Conda env for Python/backend
└── CLAUDE.md
```

## Tech Stack & Patterns

- **State management**: Riverpod (not Provider, not Bloc)
- **Database**: Drift (type-safe SQLite wrapper for Dart)
- **Navigation**: GoRouter
- **DI**: Riverpod providers, no service locators
- **Architecture**: Clean Architecture — domain layer has zero Flutter imports
- **Content format**: JSON files in `content/` dir, loaded into Drift DB on first run
- **Spaced repetition**: SM-2 algorithm variant, implemented in `domain/`

## Code Style

- Dart: follow `dart format`, use strict `analysis_options.yaml`
- All public APIs get doc comments
- Prefer `final` and immutable data classes (use `freezed` for domain entities)
- No `dynamic` types — always explicit types
- Widgets: one widget per file, file name matches widget name in snake_case
- Tests: mirror `lib/` structure under `test/`
- Python: black formatter, type hints on all functions, pydantic for models

## Domain Concepts

Six topic domains — every concept, quiz, and scenario is tagged with one or more:
1. `rl` — Reinforcement Learning (PPO, SAC, TD3, policy gradients, etc.)
2. `robot_learning` — Sim2real, manipulation, imitation learning, grasping
3. `perception` — Vision, 3D, segmentation, pose estimation, point clouds
4. `foundation_models` — LLMs, VLMs, VLAs, grounding, embodied reasoning
5. `generative_control` — Diffusion policies, action generation, multimodal prediction
6. `systems` — Deployment, evaluation, latency, safety, experiment tracking

## Key Data Entities

- **Concept**: title, definition, intuition, practical_example, failure_mode, interview_answer, tags, difficulty, importance, related_concept_ids
- **ReviewCard**: concept_id, ease_factor, interval, next_review_date, repetitions, last_quality
- **QuizQuestion**: question, options, correct_answer, explanation, concept_ids, difficulty
- **FailureScenario**: title, description, symptoms, root_cause, diagnosis_steps, domain_tags
- **InterviewPrompt**: question, time_limit_seconds, mode (engineer/manager), expected_points, concept_ids
- **UserProgress**: domain, mastery_score, total_reviews, streak_days, weak_concept_ids

## Important Constraints

- App must work fully offline — no backend dependency for core features. Sync is
  strictly additive: with no Worker configured, everything still works locally.
- The Pages site is public. Never treat the passphrase gate as access control on
  content — it protects *synced data*, not the page. Say so plainly in any UI copy.
- Passphrase crypto is duplicated in `web/src/lib/sync/crypto.ts` and
  `sync/derive-token.mjs`; a shared test vector pins them together. Change both,
  or every device loses access at once.
- Never store API keys in source code
- All content seeding happens via JSON → Drift migration, not hardcoded
- Dark mode is the default and primary theme
- Target 60fps on Linux desktop — avoid unnecessary rebuilds
- Keep concept content accurate to PhD-level robotics/ML — no dumbed-down explanations

## Current Phase

MVP — focus on: daily session flow, concept cards with spaced repetition, basic quiz, review queue, progress dashboard. Do NOT build interview mode or failure lab until MVP core is solid.

## Gotchas

- Flutter Linux desktop: use `flutter config --enable-linux-desktop` if not already enabled
- Drift code generation: run `dart run build_runner build` after changing table definitions
- Conda env is ONLY for Python/backend — never install Flutter/Dart inside conda
- `flutter doctor` must pass before any Flutter work
- GoRouter: define routes in `core/routing/`, not scattered in widgets
- Freezed: run build_runner after any entity changes
