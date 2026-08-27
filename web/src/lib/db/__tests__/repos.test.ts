import "fake-indexeddb/auto";

import { beforeEach, describe, expect, test } from "vitest";

import { exportBackup, importBackup, resetAllProgress } from "../backup";
import { db } from "../db";
import {
  completeSession,
  getDueCards,
  getUserStats,
  passLevel,
  recordReview,
  totalXp,
} from "../repos";

beforeEach(async () => {
  await resetAllProgress();
});

describe("passLevel", () => {
  test("first pass sets level, grants XP, creates review card", async () => {
    const now = new Date("2026-06-11T10:00:00Z");
    const { xpGained, newLevel } = await passLevel({
      conceptId: "ppo_clipping",
      level: 1,
      now,
    });

    expect(xpGained).toBe(20);
    expect(newLevel).toBe(1);

    const progress = await db.conceptProgress.get("ppo_clipping");
    expect(progress?.currentLevel).toBe(1);
    expect(progress?.levelPassedAt[1]).toBe(now.toISOString());

    const card = await db.reviewCards.get("ppo_clipping");
    expect(card?.level).toBe(1);
    expect(card?.nextReviewDate).toBe("2026-06-12T00:00:00.000Z");

    expect(await totalXp()).toBe(20);
  });

  test("higher pass retargets review card level, lower pass does not regress", async () => {
    await passLevel({ conceptId: "mdp", level: 1 });
    await passLevel({ conceptId: "mdp", level: 2 });
    expect((await db.reviewCards.get("mdp"))?.level).toBe(2);
    expect((await db.conceptProgress.get("mdp"))?.currentLevel).toBe(2);

    await passLevel({ conceptId: "mdp", level: 1 }); // re-pass lower level
    expect((await db.conceptProgress.get("mdp"))?.currentLevel).toBe(2);
  });
});

describe("recordReview", () => {
  test("applies SM-2 and logs confidence", async () => {
    const now = new Date("2026-06-11T10:00:00Z");
    await passLevel({ conceptId: "sac", level: 1, now });
    const card = (await db.reviewCards.get("sac"))!;

    await recordReview({
      card,
      domain: "rl",
      quality: 5,
      confidence: 4,
      now,
    });

    const updated = (await db.reviewCards.get("sac"))!;
    expect(updated.repetitions).toBe(1);
    expect(updated.lastQuality).toBe(5);
    expect(updated.easeFactor).toBeGreaterThan(2.5);

    const logs = await db.confidenceLogs.toArray();
    expect(logs).toHaveLength(1);
    expect(logs[0]).toMatchObject({ conceptId: "sac", confidence: 4, quality: 5 });
  });

  test("due card querying respects nextReviewDate", async () => {
    const now = new Date("2026-06-11T10:00:00Z");
    await passLevel({ conceptId: "gae", level: 1, now });
    expect(await getDueCards(new Date("2026-06-11T12:00:00Z"))).toHaveLength(0);
    expect(await getDueCards(new Date("2026-06-12T01:00:00Z"))).toHaveLength(1);
  });
});

describe("completeSession", () => {
  test("updates streak, totals, and grants XP", async () => {
    await completeSession({
      log: {
        length: "standard",
        reviewedCards: 10,
        quizQuestions: 5,
        quizCorrect: 4,
        avgQuality: 3.8,
        durationSec: 1200,
        xpEarned: 30,
      },
      now: new Date("2026-06-11T20:00:00"),
    });

    const stats = await getUserStats();
    expect(stats.currentStreak).toBe(1);
    expect(stats.totalSessions).toBe(1);
    expect(stats.totalReviews).toBe(10);
    expect(await totalXp()).toBe(30);

    // Next day continues the streak
    await completeSession({
      log: {
        length: "sprint",
        reviewedCards: 3,
        quizQuestions: 2,
        quizCorrect: 2,
        avgQuality: 4.2,
        durationSec: 500,
        xpEarned: 10,
      },
      now: new Date("2026-06-12T08:00:00"),
    });
    expect((await getUserStats()).currentStreak).toBe(2);
  });
});

describe("backup", () => {
  test("export/import round trip preserves all tables", async () => {
    await passLevel({ conceptId: "ppo_clipping", level: 1 });
    await passLevel({ conceptId: "ppo_clipping", level: 2 });
    await completeSession({
      log: {
        length: "standard",
        reviewedCards: 5,
        quizQuestions: 3,
        quizCorrect: 3,
        avgQuality: 4,
        durationSec: 900,
        xpEarned: 15,
      },
    });

    const backup = await exportBackup();
    const xpBefore = await totalXp();

    await resetAllProgress();
    expect(await totalXp()).toBe(0);

    await importBackup(JSON.parse(JSON.stringify(backup)));
    expect(await totalXp()).toBe(xpBefore);
    expect((await db.conceptProgress.get("ppo_clipping"))?.currentLevel).toBe(2);
    expect((await getUserStats()).totalSessions).toBe(1);
  });

  test("import rejects invalid payloads", async () => {
    await expect(importBackup({ app: "other" })).rejects.toThrow();
  });
});
