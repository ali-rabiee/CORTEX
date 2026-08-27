/** Level-up rules for concept mastery levels (new to the web app). */

/** Fraction of check questions that must be correct to pass a level. */
export const LEVEL_PASS_THRESHOLD = 0.8;

/** XP awarded for passing a concept level. */
export function xpForLevel(level: number): number {
  return level * 20;
}

export function isLevelPassed(correct: number, total: number): boolean {
  if (total === 0) return false;
  return correct / total >= LEVEL_PASS_THRESHOLD;
}
