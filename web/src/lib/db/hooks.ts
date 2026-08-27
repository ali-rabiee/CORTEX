"use client";

import { useLiveQuery } from "dexie-react-hooks";

import { xpStatus, type XpStatus } from "@/lib/engine/xp";

import { db, type ConceptProgressRow, type UserStatsRow } from "./db";

/** Live concept progress; `undefined` while loading, `null` when absent. */
export function useConceptProgress(
  conceptId: string,
): ConceptProgressRow | null | undefined {
  return useLiveQuery(
    async () => (await db.conceptProgress.get(conceptId)) ?? null,
    [conceptId],
  );
}

/** Live map of conceptId → currentLevel for list views. */
export function useAllConceptLevels(): Record<string, number> | undefined {
  return useLiveQuery(async () => {
    const rows = await db.conceptProgress.toArray();
    return Object.fromEntries(rows.map((r) => [r.conceptId, r.currentLevel]));
  }, []);
}

export function useXpStatus(): XpStatus | undefined {
  return useLiveQuery(async () => {
    const events = await db.xpEvents.toArray();
    return xpStatus(events.reduce((sum, e) => sum + e.amount, 0));
  }, []);
}

export function useUserStats(): UserStatsRow | null | undefined {
  return useLiveQuery(
    async () => (await db.userStats.get("singleton")) ?? null,
    [],
  );
}

export function useDueCardCount(now: Date): number | undefined {
  return useLiveQuery(
    () =>
      db.reviewCards
        .where("nextReviewDate")
        .belowOrEqual(now.toISOString())
        .count(),
    [now.toISOString()],
  );
}
