import { create } from "zustand";

import {
  recommendSessionLength,
  SESSION_LENGTHS,
  type SessionLength,
} from "@/lib/engine/adaptive-difficulty";
import { overconfidenceRate } from "@/lib/engine/confidence-calibration";
import { generateSession } from "@/lib/engine/generate-session";
import { db, type ReviewCardRow } from "@/lib/db/db";
import {
  completeSession,
  getDueCards,
  getEasyCards,
  recordReview,
} from "@/lib/db/repos";
import type { SessionManifest } from "@/lib/content/manifest";

/** XP rules for daily sessions. */
export const XP_PER_REVIEW = 2;
export const XP_PER_CORRECT_QUIZ = 5;

export type SessionPhase = "idle" | "warmup" | "core" | "challenge" | "summary";

type SessionQuestion = SessionManifest["questions"][number];

type SessionState = {
  phase: SessionPhase;
  length: SessionLength;
  cards: ReviewCardRow[];
  /** Index into `cards`; warmup cards come first. */
  warmupCount: number;
  cardIndex: number;
  revealed: boolean;
  pendingConfidence: number | null;
  questions: SessionQuestion[];
  questionIndex: number;
  quizCorrect: number;
  qualitySum: number;
  reviewedCount: number;
  startedAt: number | null;
  xpEarned: number;

  start: (manifest: SessionManifest, length: SessionLength) => Promise<void>;
  rateConfidence: (confidence: number) => void;
  reveal: () => void;
  rateQuality: (manifest: SessionManifest, quality: number) => Promise<void>;
  answerQuiz: (correct: boolean) => void;
  nextQuestion: () => Promise<void>;
  abort: () => void;
};

const initial = {
  phase: "idle" as SessionPhase,
  length: "standard" as SessionLength,
  cards: [],
  warmupCount: 0,
  cardIndex: 0,
  revealed: false,
  pendingConfidence: null,
  questions: [],
  questionIndex: 0,
  quizCorrect: 0,
  qualitySum: 0,
  reviewedCount: 0,
  startedAt: null,
  xpEarned: 0,
};

export const useSessionStore = create<SessionState>((set, get) => ({
  ...initial,

  start: async (manifest, length) => {
    const config = SESSION_LENGTHS[length];
    const [dueCards, easyCards] = await Promise.all([
      getDueCards(),
      getEasyCards(),
    ]);

    const session = generateSession({
      dueCards,
      easyCards: easyCards.filter(
        (c) => !dueCards.some((d) => d.conceptId === c.conceptId),
      ),
      availableQuestions: manifest.questions,
      domainOf: (id) => manifest.concepts[id]?.domain ?? "unknown",
      config,
    });

    set({
      ...initial,
      phase: session.warmupCards.length > 0 ? "warmup" : "core",
      length,
      cards: [...session.warmupCards, ...session.coreCards],
      warmupCount: session.warmupCards.length,
      questions: session.challengeQuestions,
      startedAt: Date.now(),
    });

    // Nothing to review at all → jump straight to the quiz.
    if (session.warmupCards.length + session.coreCards.length === 0) {
      set({ phase: session.challengeQuestions.length > 0 ? "challenge" : "summary" });
    }
  },

  rateConfidence: (confidence) => set({ pendingConfidence: confidence }),

  reveal: () => set({ revealed: true }),

  rateQuality: async (manifest, quality) => {
    const s = get();
    const card = s.cards[s.cardIndex];
    if (!card || s.pendingConfidence === null) return;

    const domain = manifest.concepts[card.conceptId]?.domain ?? "unknown";
    const domainLogs = await db.confidenceLogs
      .where("domain")
      .equals(domain)
      .toArray();

    await recordReview({
      card,
      domain,
      quality,
      confidence: s.pendingConfidence,
      overconfidenceRate: overconfidenceRate(domainLogs),
    });

    const nextIndex = s.cardIndex + 1;
    const done = nextIndex >= s.cards.length;
    set({
      cardIndex: nextIndex,
      revealed: false,
      pendingConfidence: null,
      qualitySum: s.qualitySum + quality,
      reviewedCount: s.reviewedCount + 1,
      xpEarned: s.xpEarned + XP_PER_REVIEW,
      phase: done
        ? get().questions.length > 0
          ? "challenge"
          : "summary"
        : nextIndex >= s.warmupCount
          ? "core"
          : "warmup",
    });

    if (done && get().questions.length === 0) {
      await finalize(get());
    }
  },

  answerQuiz: (correct) =>
    set((s) => ({
      quizCorrect: s.quizCorrect + (correct ? 1 : 0),
      xpEarned: s.xpEarned + (correct ? XP_PER_CORRECT_QUIZ : 0),
    })),

  nextQuestion: async () => {
    const s = get();
    const nextIndex = s.questionIndex + 1;
    if (nextIndex >= s.questions.length) {
      set({ phase: "summary" });
      await finalize(get());
    } else {
      set({ questionIndex: nextIndex });
    }
  },

  abort: () => set({ ...initial }),
}));

async function finalize(s: SessionState): Promise<void> {
  await completeSession({
    log: {
      length: s.length,
      reviewedCards: s.reviewedCount,
      quizQuestions: s.questions.length,
      quizCorrect: s.quizCorrect,
      avgQuality: s.reviewedCount > 0 ? s.qualitySum / s.reviewedCount : 0,
      durationSec: s.startedAt
        ? Math.round((Date.now() - s.startedAt) / 1000)
        : 0,
      xpEarned: s.xpEarned,
    },
  });
}

/** Recommended session length given current due-card count and streak. */
export async function recommendLength(): Promise<SessionLength> {
  const [due, stats] = await Promise.all([
    getDueCards(),
    db.userStats.get("singleton"),
  ]);
  const day = new Date().getDay();
  return recommendSessionLength({
    overdueCardCount: due.length,
    currentStreak: stats?.currentStreak ?? 0,
    isWeekend: day === 0 || day === 6,
  });
}
