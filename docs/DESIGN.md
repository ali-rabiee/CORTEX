# CORTEX — Design Document

> Daily cognitive training for robotics/AI professionals.
> Version 0.1 — MVP Design — 2026-03-30

---

## Table of Contents

1. [Product Architecture](#1-product-architecture)
2. [MVP Scope vs Later Phases](#2-mvp-scope-vs-later-phases)
3. [Screen-by-Screen Plan](#3-screen-by-screen-plan)
4. [Data Model / Schema](#4-data-model--schema)
5. [Folder Structure](#5-folder-structure)
6. [Ubuntu Setup Instructions](#6-ubuntu-setup-instructions)
7. [Conda Environment Setup](#7-conda-environment-setup)
8. [Daily Session Flow](#8-daily-session-flow)
9. [Example Concept Card](#9-example-concept-card)
10. [Example Debugging Scenario](#10-example-debugging-scenario)
11. [Example Interview Prompt](#11-example-interview-prompt)
12. [Future Extensibility](#12-future-extensibility)
13. [Novel Ideas](#13-novel-ideas-beyond-initial-scope)

---

## 1. Product Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    CORTEX Application                        │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Presentation Layer                       │   │
│  │  Riverpod Providers ← GoRouter ← Flutter Widgets     │   │
│  │  (Home, Session, Review, Quiz, Progress, Settings)    │   │
│  └──────────────────┬───────────────────────────────────┘   │
│                     │                                        │
│  ┌──────────────────▼───────────────────────────────────┐   │
│  │                Domain Layer                           │   │
│  │  Entities (Freezed) │ Use Cases │ Repo Interfaces     │   │
│  │  SM-2 Algorithm │ Session Generator │ Progress Calc    │   │
│  │  Confidence Calibration │ Difficulty Escalation        │   │
│  └──────────────────┬───────────────────────────────────┘   │
│                     │                                        │
│  ┌──────────────────▼───────────────────────────────────┐   │
│  │                 Data Layer                             │   │
│  │  Drift DB (SQLite) │ Repositories │ JSON Loader        │   │
│  │  Content Seeder │ Migration Manager                    │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
         │ (optional, future)
         ▼
┌─────────────────────┐
│  Python/FastAPI      │
│  Backend (conda)     │
│  - AI content gen    │
│  - Analytics         │
│  - Sync              │
└─────────────────────┘
```

### Key Architectural Decisions

| Decision | Rationale |
|----------|-----------|
| **Clean Architecture** | Domain logic is testable without Flutter. Swap UI or DB without touching business rules. |
| **Riverpod over Bloc** | Less boilerplate, better composability, native async support. Ideal for solo developer velocity. |
| **Drift over raw SQLite** | Type-safe queries, code generation, migration support. Worth the build_runner cost. |
| **Freezed entities** | Immutable domain objects with copy-with, equality, JSON serialization for free. |
| **GoRouter** | Declarative routing, deep linking support for future mobile. |
| **JSON seed content** | Content is version-controlled, diffable, editable without recompilation. Loaded into Drift on first run. |
| **Local-first** | Core app works offline. Backend is enhancement, not dependency. |
| **SM-2 variant** | Proven spaced repetition. Enhanced with confidence calibration (novel addition). |

### Data Flow

```
JSON content files → ContentSeeder → Drift DB ← Repositories → Use Cases → Riverpod Providers → Widgets
                                        ↕
                                  User interactions
                                  (review ratings, quiz answers, session completions)
```

---

## 2. MVP Scope vs Later Phases

### MVP (Phase 1) — Ship This First

Focus: **Daily review loop with spaced repetition, basic quiz, progress visibility.**

| Feature | What's Included |
|---------|----------------|
| **Home Dashboard** | Today's due reviews, streak, quick-start daily session, domain mastery overview |
| **Daily Session** | Structured 30-min session: warmup recalls → core review → quiz block → cooldown |
| **Concept Cards** | Full concept display with definition, intuition, example, failure mode, interview answer |
| **Review Queue** | SM-2 spaced repetition, quality rating (0-5), next review scheduling |
| **Basic Quiz** | Multiple-choice per concept, immediate feedback with explanation |
| **Progress Dashboard** | Per-domain mastery scores, streak tracking, review stats, weakness indicators |
| **Settings** | Session duration preference, notification toggle, theme (dark default) |
| **Content Seeding** | ~30-40 concepts across 6 domains, ~100 quiz questions |
| **Confidence Calibration** | Self-rated confidence after each recall, tracked over time (novel) |

### Phase 2 — After MVP Is Solid

| Feature | Description |
|---------|-------------|
| **Failure/Debugging Lab** | Scenario-based debugging exercises with symptom → diagnosis → root cause flow |
| **Interview Mode** | Timed explanations, engineer vs manager framing, comparison questions |
| **Explain-Back Mode** | User types explanations, keyword-based quality scoring |
| **Cross-Domain Transfer** | "You know X from RL. How does it apply to perception?" |
| **Concept Map Visualization** | Interactive graph of concept relationships |

### Phase 3 — Backend & AI Enhancement

| Feature | Description |
|---------|-------------|
| **AI Quiz Generation** | LLM-generated quiz questions from concept definitions |
| **Explanation Scoring** | LLM-evaluated quality of user explanations |
| **Content Sync** | Backend sync for multi-device usage |
| **Community Content** | Shared concept packs, quiz banks |
| **iOS / Windows Builds** | Cross-platform release |

### What's Explicitly NOT in MVP

- Interview mode (Phase 2)
- Failure lab (Phase 2)
- Concept map visualization (Phase 2)
- Backend connectivity (Phase 3)
- Voice input/scoring (Phase 3)
- Notifications/reminders beyond in-app (Phase 2)

---

## 3. Screen-by-Screen Plan

### 3.1 Home Dashboard (`/`)

**Purpose**: Daily command center. Answers "what should I do today?"

```
┌─────────────────────────────────────────┐
│  CORTEX                        [⚙ gear] │
│─────────────────────────────────────────│
│                                          │
│  ┌─────────────────────────────────┐    │
│  │  🔥 12-day streak              │    │
│  │  Today: 8 reviews due          │    │
│  │                                 │    │
│  │  [ Start Daily Session ]        │    │
│  └─────────────────────────────────┘    │
│                                          │
│  Domain Mastery                          │
│  RL              ████████░░  78%        │
│  Robot Learning  ██████░░░░  62%        │
│  Perception      █████░░░░░  54%        │
│  Foundation      ████░░░░░░  42%        │
│  Gen. Control    ███░░░░░░░  35%        │
│  Systems         ██████░░░░  61%        │
│                                          │
│  At Risk (forgetting soon)              │
│  ┌──────────┐ ┌──────────┐ ┌──────┐    │
│  │ PPO clip │ │ Sim2Real │ │ VLAs │    │
│  └──────────┘ └──────────┘ └──────┘    │
│                                          │
│  Quick Actions                          │
│  [Review Queue]  [Quiz]  [Progress]     │
│                                          │
└─────────────────────────────────────────┘
```

**Key elements**:
- Streak counter (days of consecutive review)
- Due review count with start session CTA
- Domain mastery bars (6 domains)
- "At Risk" row: concepts predicted to be forgotten this week (based on SM-2 decay)
- Quick-access buttons

### 3.2 Daily Session (`/session`)

**Purpose**: Structured training session (30-60 min configurable).

**Session structure** (novel — deliberate practice model):

```
Phase 1: WARMUP (5 min)
├── 3-5 easy concept recalls from strong domains
├── Quick confidence self-check
└── Purpose: activate retrieval circuits, build momentum

Phase 2: CORE REVIEW (15-25 min)
├── Due review cards (SM-2 scheduled)
├── Each card: reveal → self-rate quality (0-5)
├── Interleaved: concept from different domains each time
├── Confidence calibration after each
└── Purpose: spaced repetition, interleaving for durable memory

Phase 3: CHALLENGE (5-10 min)
├── Quiz questions on today's reviewed concepts
├── Mix of easy confirmations and harder applications
└── Purpose: testing effect, identify remaining gaps

Phase 4: COOLDOWN (2-3 min)
├── Session summary: cards reviewed, accuracy, weak spots
├── "Key takeaway" — one concept to think about today
├── Tomorrow's preview
└── Purpose: metacognition, planning
```

**Session screen layout**:
```
┌─────────────────────────────────────────┐
│  Daily Session          Phase 2 of 4    │
│  ████████████░░░░░░░  14/22 cards       │
│─────────────────────────────────────────│
│                                          │
│  ┌─────────────────────────────────┐    │
│  │                                 │    │
│  │     [Concept Title]             │    │
│  │                                 │    │
│  │     Can you explain this?       │    │
│  │                                 │    │
│  │     [ Tap to reveal ]           │    │
│  │                                 │    │
│  └─────────────────────────────────┘    │
│                                          │
│  After reveal:                          │
│  How well did you know this?            │
│  [0] [1] [2] [3] [4] [5]               │
│  fail  ←─────────────→  perfect         │
│                                          │
│  How confident were you?                │
│  [1] [2] [3] [4] [5]                   │
│  guess  ←──────────→  certain           │
│                                          │
└─────────────────────────────────────────┘
```

### 3.3 Concept Detail (`/concept/:id`)

**Purpose**: Full concept card view, reachable from review, quiz, or browsing.

```
┌─────────────────────────────────────────┐
│  ← Back              [rl] [robot_learning]│
│─────────────────────────────────────────│
│                                          │
│  Proximal Policy Optimization (PPO)     │
│  Difficulty: ★★★☆☆  Importance: ★★★★★  │
│                                          │
│  DEFINITION                              │
│  Policy gradient method that constrains  │
│  updates via a clipped surrogate         │
│  objective to prevent destructive large  │
│  steps in policy space.                  │
│                                          │
│  INTUITION                               │
│  Like updating your strategy with a      │
│  speed limit — you improve, but never    │
│  change so fast you forget what worked.  │
│                                          │
│  PRACTICAL EXAMPLE                       │
│  Training a robot arm reaching policy:   │
│  PPO with clip=0.2 converges stably...   │
│                                          │
│  COMMON FAILURE MODE                     │
│  Entropy collapse → policy becomes       │
│  deterministic too early, stops          │
│  exploring. Fix: entropy bonus tuning... │
│                                          │
│  INTERVIEW ANSWER                        │
│  "PPO stabilizes policy gradient         │
│  training by clipping the ratio of..."   │
│                                          │
│  RELATED CONCEPTS                        │
│  [TRPO] [SAC] [Policy Gradients] [KL]   │
│                                          │
│  Your Stats                              │
│  Reviews: 12 │ Ease: 2.5 │ Next: Apr 3  │
│  Confidence calibration: 82% accurate    │
│                                          │
└─────────────────────────────────────────┘
```

### 3.4 Review Queue (`/review`)

**Purpose**: All due and upcoming reviews, manual review access.

```
┌─────────────────────────────────────────┐
│  Review Queue                           │
│─────────────────────────────────────────│
│                                          │
│  Due Now (8)                            │
│  ┌──────────────────────────────┐       │
│  │ PPO Clipping         [rl]    │       │
│  │ Due today · Last: 3 days ago │       │
│  ├──────────────────────────────┤       │
│  │ Sim2Real Transfer    [robot] │       │
│  │ Due today · Last: 5 days ago │       │
│  ├──────────────────────────────┤       │
│  │ ...                          │       │
│  └──────────────────────────────┘       │
│                                          │
│  Coming Up                              │
│  Tomorrow (3) · This week (12)          │
│                                          │
│  [ Start Review Session ]               │
│                                          │
└─────────────────────────────────────────┘
```

### 3.5 Quiz (`/quiz`)

**Purpose**: Active testing on concepts. Part of daily session or standalone.

```
┌─────────────────────────────────────────┐
│  Quiz                    Q 3 of 10      │
│  ████████░░░░░░░░░░░                    │
│─────────────────────────────────────────│
│                                          │
│  When using PPO for robot manipulation  │
│  and the policy converges to a single   │
│  deterministic action, the most likely  │
│  cause is:                              │
│                                          │
│  ○ Learning rate too high               │
│  ○ Entropy coefficient too low          │
│  ○ Discount factor too high             │
│  ○ Batch size too small                 │
│                                          │
│  [ Submit Answer ]                      │
│                                          │
│  After answer:                          │
│  ┌─────────────────────────────────┐    │
│  │ ✓ Correct!                      │    │
│  │                                 │    │
│  │ Low entropy coefficient allows  │    │
│  │ the policy to collapse to a     │    │
│  │ single mode. In practice,       │    │
│  │ increasing entropy bonus to     │    │
│  │ 0.01-0.05 helps maintain...     │    │
│  │                                 │    │
│  │ [View Concept: PPO]             │    │
│  └─────────────────────────────────┘    │
│                                          │
└─────────────────────────────────────────┘
```

### 3.6 Progress Dashboard (`/progress`)

**Purpose**: Track improvement, identify weaknesses, maintain motivation.

```
┌─────────────────────────────────────────┐
│  Progress                               │
│─────────────────────────────────────────│
│                                          │
│  Overall Mastery: 58%                   │
│  Streak: 12 days │ Total reviews: 342   │
│                                          │
│  Domain Breakdown                        │
│  ┌─────────────────────────────────┐    │
│  │ (6 domain bars with %)          │    │
│  └─────────────────────────────────┘    │
│                                          │
│  Confidence Calibration                  │
│  ┌─────────────────────────────────┐    │
│  │ You said "confident" and were   │    │
│  │ correct 78% of the time.        │    │
│  │ Overconfident in: RL, Percep.   │    │
│  │ Underconfident in: Systems      │    │
│  └─────────────────────────────────┘    │
│                                          │
│  Weakest Concepts                        │
│  1. Diffusion Policy Sampling            │
│  2. Domain Randomization Bounds          │
│  3. VLA Action Tokenization              │
│                                          │
│  Review Heatmap (last 30 days)          │
│  ┌─────────────────────────────────┐    │
│  │ [calendar-style heatmap]        │    │
│  └─────────────────────────────────┘    │
│                                          │
│  Quiz Accuracy Trend                    │
│  ┌─────────────────────────────────┐    │
│  │ [line chart, last 4 weeks]      │    │
│  └─────────────────────────────────┘    │
│                                          │
└─────────────────────────────────────────┘
```

### 3.7 Settings (`/settings`)

**Purpose**: Personalization and app configuration.

- Session duration (30 / 45 / 60 min)
- Daily reminder time (optional)
- Focus domains (enable/disable specific domains)
- Difficulty preference (standard / hard / adaptive)
- Theme (dark / light — dark default)
- Reset progress (with confirmation)
- About / version

---

## 4. Data Model / Schema

### Drift Database Tables

```dart
// === CONCEPTS ===
class Concepts extends Table {
  TextColumn get id => text()();                    // e.g., "ppo_clipping"
  TextColumn get title => text()();                 // "Proximal Policy Optimization (PPO)"
  TextColumn get definition => text()();            // Concise definition
  TextColumn get intuition => text()();             // Practical intuition
  TextColumn get practicalExample => text()();      // Real-world example
  TextColumn get failureMode => text()();           // Common failure case
  TextColumn get interviewAnswer => text()();       // Interview-ready explanation
  TextColumn get tags => text()();                  // JSON array: ["rl", "robot_learning"]
  IntColumn get difficulty => integer()();          // 1-5
  IntColumn get importance => integer()();          // 1-5
  TextColumn get relatedConceptIds => text()();     // JSON array of concept IDs

  @override
  Set<Column> get primaryKey => {id};
}

// === REVIEW CARDS (SM-2 Spaced Repetition) ===
class ReviewCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conceptId => text().references(Concepts, #id)();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get interval => integer().withDefault(const Constant(1))();    // days
  DateTimeColumn get nextReviewDate => dateTime()();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lastQuality => integer().withDefault(const Constant(0))(); // 0-5
}

// === CONFIDENCE LOGS (Novel: calibration tracking) ===
class ConfidenceLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conceptId => text().references(Concepts, #id)();
  IntColumn get confidence => integer()();           // 1-5 self-rated
  IntColumn get quality => integer()();              // 0-5 actual performance
  DateTimeColumn get timestamp => dateTime()();
}

// === QUIZ QUESTIONS ===
class QuizQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  TextColumn get options => text()();                // JSON array of 4 options
  IntColumn get correctAnswer => integer()();        // 0-3 index
  TextColumn get explanation => text()();
  TextColumn get conceptIds => text()();             // JSON array of related concept IDs
  IntColumn get difficulty => integer()();           // 1-5
  TextColumn get tags => text()();                   // JSON array of domain tags

  @override
  Set<Column> get primaryKey => {id};
}

// === QUIZ ATTEMPTS ===
class QuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questionId => text().references(QuizQuestions, #id)();
  IntColumn get selectedAnswer => integer()();
  BoolColumn get correct => boolean()();
  DateTimeColumn get timestamp => dateTime()();
}

// === FAILURE SCENARIOS (Phase 2, schema ready) ===
class FailureScenarios extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get symptoms => text()();               // JSON array
  TextColumn get rootCause => text()();
  TextColumn get diagnosisSteps => text()();          // JSON array
  TextColumn get domainTags => text()();              // JSON array
  IntColumn get difficulty => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// === INTERVIEW PROMPTS (Phase 2, schema ready) ===
class InterviewPrompts extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  IntColumn get timeLimitSeconds => integer()();
  TextColumn get mode => text()();                   // "engineer" or "manager"
  TextColumn get expectedPoints => text()();          // JSON array
  TextColumn get conceptIds => text()();              // JSON array
  IntColumn get difficulty => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// === USER PROGRESS ===
class DomainProgress extends Table {
  TextColumn get domain => text()();                 // "rl", "perception", etc.
  RealColumn get masteryScore => real().withDefault(const Constant(0.0))();
  IntColumn get totalReviews => integer().withDefault(const Constant(0))();
  IntColumn get correctQuizAnswers => integer().withDefault(const Constant(0))();
  IntColumn get totalQuizAnswers => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {domain};
}

// === SESSION LOG ===
class SessionLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get cardsReviewed => integer()();
  IntColumn get quizCorrect => integer()();
  IntColumn get quizTotal => integer()();
  IntColumn get durationMinutes => integer()();
  RealColumn get averageQuality => real()();
}

// === STREAK TRACKING ===
class UserStats extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSessionDate => dateTime().nullable()();
  IntColumn get totalSessions => integer().withDefault(const Constant(0))();
  IntColumn get totalReviews => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### SM-2 Algorithm (Modified)

```
Input: quality (0-5), current easeFactor, interval, repetitions

If quality >= 3 (successful recall):
  if repetitions == 0: interval = 1
  else if repetitions == 1: interval = 6
  else: interval = round(interval * easeFactor)
  repetitions += 1
Else (failed recall):
  repetitions = 0
  interval = 1

easeFactor = max(1.3, easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)))
nextReviewDate = today + interval days

Enhancement: confidence calibration adjustment
  If consistently overconfident (high confidence, low quality):
    reduce interval by 20% for that concept's domain
  If consistently underconfident (low confidence, high quality):
    surface less frequently, note in progress as "stronger than you think"
```

---

## 5. Folder Structure

```
cortex/
├── app/                              # Flutter application
│   ├── lib/
│   │   ├── main.dart                 # App entry, ProviderScope, MaterialApp
│   │   ├── core/
│   │   │   ├── app_config.dart       # Constants, feature flags
│   │   │   ├── theme/
│   │   │   │   ├── app_theme.dart    # Dark/light theme definitions
│   │   │   │   └── app_colors.dart   # Color palette
│   │   │   ├── routing/
│   │   │   │   └── app_router.dart   # GoRouter configuration
│   │   │   └── utils/
│   │   │       ├── json_utils.dart   # JSON encode/decode helpers
│   │   │       └── date_utils.dart   # Date formatting helpers
│   │   ├── data/
│   │   │   ├── database/
│   │   │   │   ├── app_database.dart # Drift database definition
│   │   │   │   ├── app_database.g.dart
│   │   │   │   ├── tables/          # Table definitions
│   │   │   │   │   ├── concepts_table.dart
│   │   │   │   │   ├── review_cards_table.dart
│   │   │   │   │   ├── confidence_logs_table.dart
│   │   │   │   │   ├── quiz_questions_table.dart
│   │   │   │   │   ├── quiz_attempts_table.dart
│   │   │   │   │   ├── domain_progress_table.dart
│   │   │   │   │   ├── session_logs_table.dart
│   │   │   │   │   └── user_stats_table.dart
│   │   │   │   └── daos/
│   │   │   │       ├── concept_dao.dart
│   │   │   │       ├── review_dao.dart
│   │   │   │       ├── quiz_dao.dart
│   │   │   │       ├── progress_dao.dart
│   │   │   │       └── stats_dao.dart
│   │   │   ├── repositories/
│   │   │   │   ├── concept_repository_impl.dart
│   │   │   │   ├── review_repository_impl.dart
│   │   │   │   ├── quiz_repository_impl.dart
│   │   │   │   └── progress_repository_impl.dart
│   │   │   └── seeders/
│   │   │       └── content_seeder.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── concept.dart
│   │   │   │   ├── concept.freezed.dart
│   │   │   │   ├── review_card.dart
│   │   │   │   ├── quiz_question.dart
│   │   │   │   ├── domain_tag.dart
│   │   │   │   ├── session_config.dart
│   │   │   │   └── user_progress.dart
│   │   │   ├── repositories/
│   │   │   │   ├── concept_repository.dart
│   │   │   │   ├── review_repository.dart
│   │   │   │   ├── quiz_repository.dart
│   │   │   │   └── progress_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sm2_algorithm.dart
│   │   │       ├── generate_session.dart
│   │   │       ├── calculate_mastery.dart
│   │   │       └── confidence_calibration.dart
│   │   └── presentation/
│   │       ├── home/
│   │       │   ├── home_screen.dart
│   │       │   └── widgets/
│   │       │       ├── streak_card.dart
│   │       │       ├── domain_mastery_bars.dart
│   │       │       └── at_risk_concepts.dart
│   │       ├── daily_session/
│   │       │   ├── session_screen.dart
│   │       │   ├── session_provider.dart
│   │       │   └── widgets/
│   │       │       ├── concept_recall_card.dart
│   │       │       ├── quality_rating_bar.dart
│   │       │       ├── confidence_rating_bar.dart
│   │       │       └── session_summary.dart
│   │       ├── concept_detail/
│   │       │   └── concept_detail_screen.dart
│   │       ├── review_queue/
│   │       │   ├── review_queue_screen.dart
│   │       │   └── review_queue_provider.dart
│   │       ├── quiz/
│   │       │   ├── quiz_screen.dart
│   │       │   ├── quiz_provider.dart
│   │       │   └── widgets/
│   │       │       ├── quiz_option_tile.dart
│   │       │       └── quiz_explanation_card.dart
│   │       ├── progress/
│   │       │   ├── progress_screen.dart
│   │       │   ├── progress_provider.dart
│   │       │   └── widgets/
│   │       │       ├── mastery_chart.dart
│   │       │       ├── calibration_card.dart
│   │       │       ├── weakness_list.dart
│   │       │       └── review_heatmap.dart
│   │       ├── settings/
│   │       │   └── settings_screen.dart
│   │       └── shared/
│   │           ├── domain_tag_chip.dart
│   │           ├── difficulty_stars.dart
│   │           └── loading_indicator.dart
│   ├── test/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── sm2_algorithm_test.dart
│   │   │       └── generate_session_test.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   └── presentation/
│   ├── analysis_options.yaml
│   └── pubspec.yaml
├── backend/                          # Python/FastAPI (conda env)
│   ├── main.py
│   ├── routers/
│   │   └── health.py
│   ├── models/
│   ├── services/
│   ├── tests/
│   │   └── test_health.py
│   └── requirements.txt
├── content/                          # Shared seed data (JSON)
│   ├── concepts/
│   │   ├── rl.json
│   │   ├── robot_learning.json
│   │   ├── perception.json
│   │   ├── foundation_models.json
│   │   ├── generative_control.json
│   │   └── systems.json
│   ├── quizzes/
│   │   ├── rl_quiz.json
│   │   ├── robot_learning_quiz.json
│   │   ├── perception_quiz.json
│   │   ├── foundation_models_quiz.json
│   │   ├── generative_control_quiz.json
│   │   └── systems_quiz.json
│   ├── failure_scenarios/            # Phase 2
│   └── interview_prompts/            # Phase 2
├── scripts/
│   ├── setup_ubuntu.sh               # System deps + Flutter verification
│   └── seed_content.py               # Content validation/generation utilities
├── docs/
│   └── DESIGN.md                     # This file
├── environment.yml                   # Conda env spec
├── CLAUDE.md                         # Developer instructions
├── LICENSE
└── README.md
```

---

## 6. Ubuntu Setup Instructions

### A. System-Level Setup (Flutter + Linux Desktop)

```bash
# 1. Install Linux desktop build dependencies
sudo apt update
sudo apt install -y \
  clang cmake git ninja-build pkg-config \
  libgtk-3-dev liblzma-dev libstdc++-12-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  mesa-utils

# 2. Install Flutter SDK (if not already installed)
# Option A: Snap (recommended for Ubuntu)
sudo snap install flutter --classic

# Option B: Manual install
# git clone https://github.com/flutter/flutter.git -b stable ~/flutter
# export PATH="$HOME/flutter/bin:$PATH"

# 3. Enable Linux desktop
flutter config --enable-linux-desktop

# 4. Verify installation
flutter doctor

# Expected: Flutter, Chrome, Linux toolchain should all be ✓
# Android toolchain ✗ is fine — we don't need it for MVP
```

### B. Project Setup

```bash
# Clone and enter project
git clone <repo-url> cortex && cd cortex

# Set up Flutter app
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cd ..

# Set up conda environment (see next section)
conda env create -f environment.yml
```

---

## 7. Conda Environment Setup

### environment.yml

```yaml
name: cortex
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.11
  - pip
  - pip:
    - fastapi>=0.110.0
    - uvicorn[standard]>=0.29.0
    - pydantic>=2.6.0
    - pytest>=8.0.0
    - black>=24.2.0
    - httpx>=0.27.0       # For testing FastAPI
    - pyyaml>=6.0.0       # Content processing
    - rich>=13.0.0        # CLI utilities
```

### Setup Commands

```bash
# Create environment
conda env create -f environment.yml

# Activate
conda activate cortex

# Verify
python -c "import fastapi; print(f'FastAPI {fastapi.__version__}')"
uvicorn --version

# Run backend (when ready)
cd backend && uvicorn main:app --reload

# Run tests
cd backend && pytest

# Deactivate when switching to Flutter work
conda deactivate
```

**Important**: Never install Flutter/Dart inside conda. Flutter uses system-level installation. Conda is exclusively for Python/backend tooling.

---

## 8. Daily Session Flow

### Example: 30-Minute Session

```
SESSION START
├── Load user: 12-day streak, 8 due reviews, weakest domain = generative_control
│
├── PHASE 1: WARMUP (5 min, 4 cards)
│   ├── Card 1: "What is policy gradient?" [rl, easy, last review 2 days ago]
│   │   └── User rates: quality=5, confidence=5 → fast pass, schedule +10 days
│   ├── Card 2: "What is YOLO used for?" [perception, easy]
│   │   └── User rates: quality=4, confidence=4 → schedule +6 days
│   ├── Card 3: "What is experiment tracking?" [systems, easy]
│   │   └── User rates: quality=5, confidence=4 → fast pass
│   └── Card 4: "What is behavior cloning?" [robot_learning, easy]
│       └── User rates: quality=4, confidence=5 → schedule +8 days
│
├── PHASE 2: CORE REVIEW (18 min, 8 cards — the due reviews)
│   ├── Card 5: "PPO clipping mechanism" [rl, medium]
│   │   └── User reveals → struggles → quality=2, confidence=3
│   │   └── SM-2: reset interval to 1 day, flag as weak
│   │   └── Calibration: overconfident (conf=3, qual=2), log it
│   ├── Card 6: "Sim2real domain randomization" [robot_learning, hard]
│   │   └── quality=3, confidence=2 → ok recall, underconfident
│   ├── Card 7: "Diffusion policy noise schedule" [generative_control, hard]
│   │   └── quality=1, confidence=1 → failed, reset, will see again tomorrow
│   ├── Card 8: "Point cloud preprocessing" [perception, medium]
│   │   └── quality=4, confidence=4 → good
│   ├── ...4 more cards interleaved across domains...
│
├── PHASE 3: CHALLENGE (5 min, 5 quiz questions)
│   ├── Q1: PPO entropy collapse (from failed Card 5) → correct!
│   ├── Q2: Sim2real randomization bounds → correct
│   ├── Q3: Diffusion policy sampling → incorrect → show explanation
│   ├── Q4: Point cloud downsampling methods → correct
│   └── Q5: Cross-domain: "How does distribution shift in RL relate
│           to sim2real gap?" → correct
│
├── PHASE 4: COOLDOWN (2 min)
│   ├── Summary:
│   │   ├── 12 cards reviewed, avg quality 3.4
│   │   ├── Quiz: 4/5 correct (80%)
│   │   ├── Weak spots: PPO clipping, diffusion noise
│   │   ├── Calibration: slightly overconfident in RL today
│   │   └── Streak: 13 days!
│   └── Key takeaway: "Review diffusion policy noise schedules —
│       the connection between noise variance and action smoothness
│       is a common interview topic."
│   └── Tomorrow preview: "6 reviews due, including PPO clipping (again)"
│
SESSION END → Update streak, log session, recalculate domain mastery
```

---

## 9. Example Concept Card

```json
{
  "id": "ppo_clipping",
  "title": "Proximal Policy Optimization (PPO) — Clipping Mechanism",
  "definition": "PPO constrains policy updates by clipping the probability ratio r(θ) = π_new(a|s)/π_old(a|s) to [1-ε, 1+ε], preventing destructively large policy changes. The clipped surrogate objective is: L^CLIP = E[min(r(θ)·A, clip(r(θ), 1-ε, 1+ε)·A)].",
  "intuition": "Imagine updating your driving strategy after a bad day. Without clipping, you might overcorrect — go from 'too aggressive' to 'refuse to merge.' PPO's clip (typically ε=0.2) is a speed limit on how much your policy can change in one update. The min() ensures you only get the pessimistic (conservative) benefit of the change.",
  "practical_example": "Training a robot arm to stack blocks using PPO with ε=0.2. After 500K env steps, the policy reliably reaches 85% success. Compare: vanilla policy gradient diverged at 200K steps. Key implementation detail: PPO needs multiple epochs (typically 3-10) per batch of experience, unlike TRPO which takes one constrained step.",
  "failure_mode": "Entropy collapse: the policy becomes deterministic too early, converging to a single action mode. Symptoms: reward plateaus, action distribution variance → 0. Root cause: entropy coefficient too low or no entropy bonus. Fix: add entropy bonus (0.01-0.05), monitor policy entropy, use early stopping if entropy drops below threshold. Also watch for value function clipping issues — clipping the value loss is debated but can help stability.",
  "interview_answer": "PPO stabilizes policy gradient training by clipping the importance sampling ratio between old and new policies. The key insight is the min of clipped and unclipped objectives — this creates a pessimistic bound that prevents destructive updates. In practice, PPO with ε=0.2, batch_size=2048, 10 epochs per update, and an entropy bonus of 0.01 is a strong default for continuous control. Compared to TRPO, PPO is simpler (no conjugate gradient / line search) and scales better, though TRPO has tighter theoretical guarantees.",
  "tags": ["rl", "robot_learning"],
  "difficulty": 3,
  "importance": 5,
  "related_concept_ids": ["trpo", "policy_gradients", "kl_divergence", "entropy_regularization", "sac", "value_function_estimation"]
}
```

---

## 10. Example Debugging Scenario

```json
{
  "id": "ppo_reward_plateau",
  "title": "PPO Training Plateaus After Initial Progress",
  "description": "You're training a 7-DOF robot arm for bin picking using PPO in Isaac Gym. The policy reaches 40% success rate within 1M steps, then flatlines for the next 5M steps. The reward curve shows occasional spikes but no sustained improvement.",
  "symptoms": [
    "Reward plateaus at ~40% success after initial learning",
    "Policy entropy has dropped from 2.1 to 0.3",
    "Value loss is low and stable (the value function fits well)",
    "KL divergence between old and new policy is near zero",
    "Action distribution is nearly deterministic — std dev < 0.01"
  ],
  "root_cause": "Premature entropy collapse. The policy committed to a narrow strategy (e.g., always approaching from one angle) that works 40% of the time. With near-zero entropy, it can't explore alternative grasp strategies. The low KL divergence confirms the policy isn't updating meaningfully — it's stuck.",
  "diagnosis_steps": [
    "1. Check policy entropy over training: plot H(π) vs steps. If it collapsed early (< 500K steps), this is the primary suspect.",
    "2. Visualize the action distribution: if std dev ≈ 0, the policy is deterministic.",
    "3. Check if the 40% success corresponds to a specific object subset or grasp type — confirms the policy found one strategy and stopped.",
    "4. Verify entropy coefficient: if using default 0.0 or very low (< 0.001), this is likely the cause.",
    "5. Check if value function is overfit: low value loss + plateau can mean the critic is too confident, giving small advantages that don't drive exploration."
  ],
  "domain_tags": ["rl", "robot_learning"],
  "difficulty": 3
}
```

---

## 11. Example Interview Prompt

```json
{
  "id": "ppo_vs_sac",
  "question": "Compare PPO and SAC for robot manipulation tasks. When would you choose each? What are the practical trade-offs in terms of sample efficiency, stability, and deployment?",
  "time_limit_seconds": 180,
  "mode": "engineer",
  "expected_points": [
    "PPO is on-policy (less sample efficient) vs SAC is off-policy (more sample efficient due to replay buffer)",
    "PPO is simpler to tune — fewer hyperparameters, no target network / automatic temperature",
    "SAC handles continuous action spaces naturally with reparameterization trick",
    "PPO is more stable for sim2real because on-policy updates are less likely to exploit simulator artifacts in the replay buffer",
    "SAC's entropy maximization encourages exploration, reducing entropy collapse issues",
    "For real-robot training (expensive data): SAC's sample efficiency wins",
    "For sim training with parallel envs: PPO scales better (vectorized, no replay buffer memory)",
    "Practical deployment: PPO's deterministic policy (after training) is simpler; SAC needs to handle the stochastic policy at test time (typically take mean)"
  ],
  "concept_ids": ["ppo_clipping", "sac", "on_policy_vs_off_policy", "sample_efficiency"],
  "difficulty": 3
}
```

---

## 12. Future Extensibility

### Technical Extensibility

| Area | Approach |
|------|----------|
| **New content** | Drop JSON files into `content/`, run seeder. No code changes needed. |
| **New domains** | Add to `DomainTag` enum, create JSON content file. Everything else adapts. |
| **Backend integration** | Repository interfaces already abstracted. Swap Drift impl for API-backed impl. |
| **iOS / Windows** | Flutter handles this. Same codebase, platform-specific only for SQLite path. |
| **AI features** | Backend endpoints for quiz generation, explanation scoring. App calls optionally. |
| **Content packs** | JSON bundles that can be imported. Share concept sets between users. |

### Feature Extensibility Roadmap

```
MVP (now)
 └→ Phase 2: Failure Lab + Interview Mode
     └→ Phase 3: Backend + AI quiz gen + explanation scoring
         └→ Phase 4: iOS/Windows release + sync
             └→ Phase 5: Community content + social features
```

### Architecture Decisions That Enable Extensibility

1. **Repository pattern** — swap storage backend without touching domain/presentation
2. **JSON content** — non-developers can contribute concepts by editing JSON
3. **Riverpod providers** — easy to add new features as independent provider trees
4. **GoRouter** — new screens are a single route addition
5. **Domain tags as enum** — type-safe, exhaustive switch statements catch missing domains
6. **SM-2 as pure function** — easy to A/B test algorithm variants

---

## 13. Novel Ideas Beyond Initial Scope

### Implemented in MVP

#### 13.1 Confidence Calibration
**What**: After each concept recall, the user rates their confidence (1-5) separately from quality. Over time, track calibration accuracy.

**Why**: Metacognitive research shows that knowing *what you don't know* is as important as knowledge itself. Overconfidence in RL doesn't show up in standard review — you think you know PPO but botch the interview explanation. Underconfidence wastes review time on strong concepts.

**How it improves learning**: The progress dashboard shows "You said confident and were wrong 35% of the time in RL" — this is a powerful wake-up call. The algorithm can also adjust: overconfident concepts get shorter intervals (more frequent review).

#### 13.2 Deliberate Practice Session Structure
**What**: Sessions follow warmup → core → challenge → cooldown, not just a flat review queue.

**Why**: Borrowed from athletic training and deliberate practice research (Ericsson). Cold-start reviews are less effective. The warmup activates retrieval circuits. The challenge phase (quiz) forces deeper processing. The cooldown enables metacognition.

#### 13.3 "At Risk" Forgetting Prediction
**What**: Home screen shows concepts predicted to be forgotten this week based on SM-2 decay curves.

**Why**: Creates urgency without gamification. "PPO clipping is fading" is more motivating than "you have 8 reviews." It's proactive rather than reactive.

### Planned for Phase 2+

#### 13.4 Cross-Domain Transfer Prompts
**What**: "You understand policy gradients in RL. How does the gradient signal problem relate to vanishing gradients in deep perception networks?"

**Why**: Industry interviews test connecting ideas across domains. This is the hardest thing to practice alone. These prompts force the user to build bridges between knowledge silos.

#### 13.5 Difficulty Escalation Ladders
**What**: Each concept has skill levels: Recognize → Explain → Apply → Debug → Teach. Different interaction types at each level.

**Why**: Recognizing "PPO" in a multiple-choice is not the same as debugging PPO entropy collapse or teaching it to a junior engineer. The ladder ensures the user progresses through all competency levels.

#### 13.6 Explanation Quality Scoring
**What**: User types a 2-3 sentence explanation. System scores it via keyword matching (MVP) or LLM evaluation (Phase 3).

**Why**: The generation effect — producing an explanation creates stronger memory than recognizing one. Even crude keyword scoring ("did you mention clipping ratio, surrogate objective, epsilon?") adds value.

#### 13.7 "What Industry Actually Cares About" Overlay
**What**: Each concept has an optional "industry reality" note: what companies actually test, what gets asked in interviews vs what's theoretical, what breaks in production.

**Why**: PhD researchers often over-index on theory. This overlay bridges the gap: "Yes, you know the math behind TRPO, but in practice everyone uses PPO because it's simpler and scales to vectorized envs."

#### 13.8 Spaced Repetition for Quiz Errors
**What**: When a quiz question is answered wrong, the underlying concepts get their SM-2 intervals shortened. The specific question re-appears in 1-3 sessions.

**Why**: Standard spaced repetition only operates on concept cards. But quiz errors reveal a different kind of gap — application failure, not recall failure. Linking quiz performance back to the review schedule creates a tighter feedback loop.

#### 13.9 Session Difficulty Adaptation
**What**: If the user consistently scores 4-5 quality across a session, the next session pulls harder concepts and reduces warmup. If they struggle (avg < 3), increase warmup and reduce session length.

**Why**: Prevents the "too easy, I'm just going through motions" problem and the "too hard, I'm demoralized" problem. Keeps the user in their zone of proximal development.

#### 13.10 Concept Compression Drills (Phase 3)
**What**: "Explain PPO in exactly 1 sentence. Now explain it in exactly 3 sentences. Now explain it to a manager in 2 sentences."

**Why**: Interview readiness isn't just knowing — it's knowing at multiple levels of compression. The ability to give a crisp 1-sentence answer vs a detailed 3-sentence answer is a distinct skill.

---

## Appendix: Design Principles

1. **Respect the user's expertise** — No hand-holding, no dumbed-down explanations. This is a tool for a PhD-level researcher, not a beginner tutorial.

2. **Active over passive** — Every interaction requires the user to produce something (recall, rate, answer, explain). No passive reading screens.

3. **Honest feedback** — Show weaknesses clearly. Don't inflate progress. Calibration tracking means the app tells you when you're fooling yourself.

4. **Speed and focus** — 30-minute sessions should feel intense and productive. No loading screens, no unnecessary animations, no clicking through menus.

5. **Content is king** — The concepts, quizzes, and scenarios must be PhD-level accurate and practically useful. Bad content makes everything else worthless.

6. **Build for one user first** — This is a solo-user tool. Don't over-engineer for multi-user, cloud sync, or social features until the core loop is proven.
