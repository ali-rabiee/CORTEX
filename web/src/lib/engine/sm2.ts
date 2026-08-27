import { addDays, utcDayStart } from "./time";

/**
 * Modified SM-2 spaced repetition algorithm with confidence-calibration
 * adjustment. Direct port of the Flutter app's
 * `app/lib/domain/usecases/sm2_algorithm.dart`, with `now` injectable.
 */

export type Sm2Input = {
  /** Recall quality 0–5 (0 = blackout, 5 = perfect). */
  quality: number;
  easeFactor: number;
  /** Current interval in days. */
  interval: number;
  /** Count of consecutive successful recalls. */
  repetitions: number;
  /** Historical rate (0–1) of being wrong while confident, per domain. */
  overconfidenceRate?: number;
  now?: Date;
};

export type Sm2Result = {
  easeFactor: number;
  interval: number;
  repetitions: number;
  /** ISO timestamp at UTC midnight. */
  nextReviewDate: string;
};

export const MIN_EASE_FACTOR = 1.3;

export function calculateSm2({
  quality,
  easeFactor,
  interval,
  repetitions,
  overconfidenceRate,
  now = new Date(),
}: Sm2Input): Sm2Result {
  let newInterval: number;
  let newRepetitions: number;

  if (quality >= 3) {
    // Successful recall
    if (repetitions === 0) {
      newInterval = 1;
    } else if (repetitions === 1) {
      newInterval = 6;
    } else {
      newInterval = Math.round(interval * easeFactor);
    }
    newRepetitions = repetitions + 1;
  } else {
    // Failed recall — reset
    newRepetitions = 0;
    newInterval = 1;
  }

  let newEaseFactor =
    easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  newEaseFactor = Math.max(MIN_EASE_FACTOR, newEaseFactor);

  // Confidence calibration: historically overconfident users get shortened
  // intervals to force more frequent review.
  if (overconfidenceRate !== undefined && overconfidenceRate > 0.3) {
    const reduction = 1.0 - (overconfidenceRate - 0.3) * 0.5;
    newInterval = Math.max(1, Math.round(newInterval * reduction));
  }

  return {
    easeFactor: newEaseFactor,
    interval: newInterval,
    repetitions: newRepetitions,
    nextReviewDate: addDays(utcDayStart(now), newInterval).toISOString(),
  };
}
