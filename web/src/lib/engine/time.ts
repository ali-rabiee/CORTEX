/**
 * Date conventions for the engine: review scheduling works in whole days,
 * pinned to UTC midnight so intervals and streaks never drift across DST.
 * Persisted dates are ISO strings.
 */

export const DAY_MS = 86_400_000;

/** UTC midnight of the given instant. */
export function utcDayStart(date: Date): Date {
  return new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  );
}

export function addDays(date: Date, days: number): Date {
  return new Date(date.getTime() + days * DAY_MS);
}

/** Calendar day key, e.g. "2026-06-11". Uses the LOCAL calendar day, since a
 * "daily session" follows the user's wall clock. */
export function localDayKey(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

/** Whole days between two local day keys (b - a). */
export function daysBetweenDayKeys(a: string, b: string): number {
  return Math.round((Date.parse(b) - Date.parse(a)) / DAY_MS);
}

/** True if the card is due at `now` (compares against UTC day start). */
export function isDue(nextReviewDate: string, now: Date): boolean {
  return Date.parse(nextReviewDate) <= now.getTime();
}
