/**
 * Adaptive difficulty engine. Port of
 * `app/lib/domain/usecases/adaptive_difficulty.dart`, with missions
 * generalized to concept-level checks ("boss" ≙ the L5 application check).
 */

export type DifficultyTier = 1 | 2 | 3 | 4;

export const TIER_LABELS: Record<DifficultyTier, string> = {
  1: "Beginner",
  2: "Intermediate",
  3: "Advanced",
  4: "Expert",
};

/** Tier for quiz/check selection given concept mastery (0–1). */
export function selectTier({
  mastery,
  isBoss = false,
  earlyInChapter = false,
}: {
  mastery: number;
  /** L5 "boss" checks push one tier up. */
  isBoss?: boolean;
  /** Early chapter content caps at Intermediate. */
  earlyInChapter?: boolean;
}): DifficultyTier {
  let tier: DifficultyTier;
  if (mastery < 0.2) tier = 1;
  else if (mastery < 0.5) tier = 2;
  else if (mastery < 0.75) tier = 3;
  else tier = 4;

  if (isBoss) return Math.min(4, tier + 1) as DifficultyTier;
  if (earlyInChapter && tier > 2) return 2;
  return tier;
}

export type SessionDifficultyProfile = {
  tierRatios: Record<DifficultyTier, number>;
  reviewPriority: number;
  confidenceCheckRatio: number;
};

/** Session composition based on recent performance. */
export function computeSessionProfile({
  recentAccuracy,
  overdueCardCount,
  confidenceCalibrationError,
}: {
  recentAccuracy: number;
  overdueCardCount: number;
  confidenceCalibrationError: number;
}): SessionDifficultyProfile {
  let tierRatios: Record<DifficultyTier, number>;
  if (recentAccuracy < 0.7) {
    tierRatios = { 1: 0.4, 2: 0.35, 3: 0.2, 4: 0.05 };
  } else if (recentAccuracy > 0.9) {
    tierRatios = { 1: 0.1, 2: 0.2, 3: 0.4, 4: 0.3 };
  } else {
    tierRatios = { 1: 0.2, 2: 0.3, 3: 0.35, 4: 0.15 };
  }

  return {
    tierRatios,
    reviewPriority: overdueCardCount > 15 ? 0.8 : 0.5,
    confidenceCheckRatio: confidenceCalibrationError > 0.2 ? 0.2 : 0.05,
  };
}

export type SessionLength = "sprint" | "standard" | "deep";

export const SESSION_LENGTHS: Record<
  SessionLength,
  {
    minutes: number;
    label: string;
    warmupCards: number;
    coreReviewCards: number;
    challengeQuestions: number;
  }
> = {
  sprint: { minutes: 10, label: "Sprint", warmupCards: 3, coreReviewCards: 3, challengeQuestions: 2 },
  standard: { minutes: 25, label: "Standard", warmupCards: 4, coreReviewCards: 10, challengeQuestions: 5 },
  deep: { minutes: 45, label: "Deep Dive", warmupCards: 5, coreReviewCards: 15, challengeQuestions: 8 },
};

export function recommendSessionLength({
  overdueCardCount,
  currentStreak,
  isWeekend,
}: {
  overdueCardCount: number;
  currentStreak: number;
  isWeekend: boolean;
}): SessionLength {
  if (overdueCardCount > 20) return "standard";
  if (isWeekend && currentStreak >= 7) return "deep";
  if (overdueCardCount < 5) return "sprint";
  return "standard";
}
