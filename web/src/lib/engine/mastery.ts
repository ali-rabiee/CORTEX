/**
 * Domain mastery scoring. Port of
 * `app/lib/domain/usecases/calculate_mastery.dart` — weights preserved:
 * 40% normalized ease, 35% stable-card ratio, 25% quiz accuracy.
 */

export type MasteryCard = {
  easeFactor: number;
  /** Interval in days. */
  interval: number;
};

export function calculateDomainMastery({
  cards,
  quizCorrect,
  quizTotal,
}: {
  cards: MasteryCard[];
  quizCorrect: number;
  quizTotal: number;
}): number {
  if (cards.length === 0) return 0;

  const avgEase =
    cards.reduce((sum, c) => sum + c.easeFactor, 0) / cards.length;
  const easeScore = clamp01((avgEase - 1.3) / (3.0 - 1.3));

  const stableCards = cards.filter((c) => c.interval > 7).length;
  const stabilityScore = stableCards / cards.length;

  const quizScore = quizTotal > 0 ? quizCorrect / quizTotal : 0;

  return clamp01(easeScore * 0.4 + stabilityScore * 0.35 + quizScore * 0.25);
}

function clamp01(x: number): number {
  return Math.min(1, Math.max(0, x));
}
