import { MIN_EASE_FACTOR, calculateSm2 } from "@/lib/engine/sm2";
import { xpForLevel } from "@/lib/engine/levels";
import { updateStreak } from "@/lib/engine/streak";
import { localDayKey, utcDayStart } from "@/lib/engine/time";

import {
  db,
  type ConceptProgressRow,
  type ReviewCardRow,
  type SessionLogRow,
  type UserStatsRow,
} from "./db";

/** Repository layer: the only module that touches Dexie. Engine modules stay
 * pure; UI components call these (or subscribe via useLiveQuery). */

const DEFAULT_EASE = 2.5;

export async function getUserStats(): Promise<UserStatsRow> {
  return (
    (await db.userStats.get("singleton")) ?? {
      id: "singleton",
      currentStreak: 0,
      longestStreak: 0,
      lastSessionDay: null,
      totalSessions: 0,
      totalReviews: 0,
    }
  );
}

/**
 * Record a passed level check: bump concept level, grant XP, and (re)target
 * the concept's review card at the new level.
 */
export async function passLevel({
  conceptId,
  level,
  now = new Date(),
}: {
  conceptId: string;
  level: number;
  now?: Date;
}): Promise<{ xpGained: number; newLevel: number }> {
  const xpGained = xpForLevel(level);
  await db.transaction(
    "rw",
    [db.conceptProgress, db.xpEvents, db.reviewCards],
    async () => {
      const existing = await db.conceptProgress.get(conceptId);
      const progress: ConceptProgressRow = existing ?? {
        conceptId,
        currentLevel: 0,
        levelPassedAt: {},
        checkAttempts: 0,
      };
      if (level > progress.currentLevel) {
        progress.currentLevel = level;
      }
      progress.levelPassedAt = { ...progress.levelPassedAt, [level]: now.toISOString() };
      await db.conceptProgress.put(progress);

      await db.xpEvents.add({
        kind: "level_pass",
        amount: xpGained,
        ref: `${conceptId}:l${level}`,
        timestamp: now.toISOString(),
      });

      // Reviews track the highest level you've reached: first pass creates the
      // card (due tomorrow), later passes retarget the prompt level.
      const card = await db.reviewCards.get(conceptId);
      if (!card) {
        await db.reviewCards.put({
          conceptId,
          easeFactor: DEFAULT_EASE,
          interval: 1,
          repetitions: 0,
          lastQuality: null,
          level: progress.currentLevel,
          nextReviewDate: new Date(
            utcDayStart(now).getTime() + 86_400_000,
          ).toISOString(),
          createdAt: now.toISOString(),
        });
      } else if (progress.currentLevel > card.level) {
        await db.reviewCards.update(conceptId, { level: progress.currentLevel });
      }
    },
  );
  const updated = await db.conceptProgress.get(conceptId);
  return { xpGained, newLevel: updated?.currentLevel ?? level };
}

export async function recordCheckAttempt(conceptId: string): Promise<void> {
  const existing = await db.conceptProgress.get(conceptId);
  if (existing) {
    await db.conceptProgress.update(conceptId, {
      checkAttempts: existing.checkAttempts + 1,
    });
  } else {
    await db.conceptProgress.put({
      conceptId,
      currentLevel: 0,
      levelPassedAt: {},
      checkAttempts: 1,
    });
  }
}

/** Apply a review answer: SM-2 update + confidence log. */
export async function recordReview({
  card,
  domain,
  quality,
  confidence,
  overconfidenceRate,
  now = new Date(),
}: {
  card: ReviewCardRow;
  domain: string;
  quality: number;
  confidence: number;
  overconfidenceRate?: number;
  now?: Date;
}): Promise<void> {
  const result = calculateSm2({
    quality,
    easeFactor: Math.max(MIN_EASE_FACTOR, card.easeFactor),
    interval: card.interval,
    repetitions: card.repetitions,
    overconfidenceRate,
    now,
  });
  await db.transaction("rw", [db.reviewCards, db.confidenceLogs], async () => {
    await db.reviewCards.update(card.conceptId, {
      easeFactor: result.easeFactor,
      interval: result.interval,
      repetitions: result.repetitions,
      lastQuality: quality,
      nextReviewDate: result.nextReviewDate,
    });
    await db.confidenceLogs.add({
      conceptId: card.conceptId,
      domain,
      confidence,
      quality,
      timestamp: now.toISOString(),
    });
  });
}

/** Log a completed session: stats, streak, XP. */
export async function completeSession({
  log,
  now = new Date(),
}: {
  log: Omit<SessionLogRow, "id" | "date" | "completedAt">;
  now?: Date;
}): Promise<void> {
  await db.transaction(
    "rw",
    [db.sessionLogs, db.userStats, db.xpEvents],
    async () => {
      await db.sessionLogs.add({
        ...log,
        date: localDayKey(now),
        completedAt: now.toISOString(),
      });

      const stats = await getUserStats();
      const streak = updateStreak(
        {
          currentStreak: stats.currentStreak,
          longestStreak: stats.longestStreak,
          lastSessionDay: stats.lastSessionDay,
        },
        now,
      );
      await db.userStats.put({
        ...stats,
        ...streak,
        totalSessions: stats.totalSessions + 1,
        totalReviews: stats.totalReviews + log.reviewedCards,
      });

      if (log.xpEarned > 0) {
        await db.xpEvents.add({
          kind: "session",
          amount: log.xpEarned,
          ref: `session:${localDayKey(now)}`,
          timestamp: now.toISOString(),
        });
      }
    },
  );
}

export async function totalXp(): Promise<number> {
  const events = await db.xpEvents.toArray();
  return events.reduce((sum, e) => sum + e.amount, 0);
}

/** Cards due for review at `now`. */
export async function getDueCards(now = new Date()): Promise<ReviewCardRow[]> {
  return db.reviewCards
    .where("nextReviewDate")
    .belowOrEqual(now.toISOString())
    .toArray();
}

/** Well-known cards (high ease, successfully repeated) for session warmup. */
export async function getEasyCards(): Promise<ReviewCardRow[]> {
  return db.reviewCards
    .filter((c) => c.easeFactor >= 2.3 && c.repetitions >= 1)
    .toArray();
}
