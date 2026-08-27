import { daysBetweenDayKeys, localDayKey } from "./time";

/** Streak bookkeeping over local calendar days. */

export type StreakState = {
  currentStreak: number;
  longestStreak: number;
  /** Local day key of the last completed session, e.g. "2026-06-11". */
  lastSessionDay: string | null;
};

/** Apply a completed session at `now` to the streak state. Idempotent within
 * the same calendar day. */
export function updateStreak(state: StreakState, now: Date): StreakState {
  const today = localDayKey(now);
  if (state.lastSessionDay === today) return state;

  const gap =
    state.lastSessionDay === null
      ? Infinity
      : daysBetweenDayKeys(state.lastSessionDay, today);

  const currentStreak = gap === 1 ? state.currentStreak + 1 : 1;
  return {
    currentStreak,
    longestStreak: Math.max(state.longestStreak, currentStreak),
    lastSessionDay: today,
  };
}

/** True if the streak is broken as of `now` (no session yesterday or today). */
export function isStreakStale(state: StreakState, now: Date): boolean {
  if (state.lastSessionDay === null) return false;
  return daysBetweenDayKeys(state.lastSessionDay, localDayKey(now)) > 1;
}
