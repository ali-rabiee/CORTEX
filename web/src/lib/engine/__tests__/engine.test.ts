import { describe, expect, test } from "vitest";

import {
  computeSessionProfile,
  recommendSessionLength,
  selectTier,
} from "../adaptive-difficulty";
import {
  analyzeCalibration,
  overconfidenceRate,
} from "../confidence-calibration";
import { generateSession } from "../generate-session";
import { isLevelPassed, xpForLevel } from "../levels";
import { calculateDomainMastery } from "../mastery";
import { isStreakStale, updateStreak, type StreakState } from "../streak";
import {
  chapterProgress,
  isChapterUnlocked,
  isWorldUnlocked,
  type ChapterLike,
} from "../unlock";
import { cumulativeXpForLevel, xpStatus } from "../xp";

describe("confidence calibration", () => {
  test("empty logs yield neutral calibration", () => {
    const r = analyzeCalibration([]);
    expect(r.calibrationRatio).toBe(1);
    expect(r.isOverconfident).toBe(false);
  });

  test("confident but wrong answers flag overconfidence", () => {
    const logs = Array.from({ length: 10 }, () => ({
      confidence: 5,
      quality: 1,
    }));
    const r = analyzeCalibration(logs);
    expect(r.highConfidenceAccuracy).toBe(0);
    expect(r.isOverconfident).toBe(true);
  });

  test("overconfidence rate requires at least 5 high-confidence logs", () => {
    const few = Array.from({ length: 4 }, () => ({ confidence: 5, quality: 0 }));
    expect(overconfidenceRate(few)).toBe(0);
    const enough = Array.from({ length: 5 }, () => ({ confidence: 5, quality: 0 }));
    expect(overconfidenceRate(enough)).toBe(1);
  });
});

describe("domain mastery", () => {
  test("no cards yields zero", () => {
    expect(
      calculateDomainMastery({ cards: [], quizCorrect: 5, quizTotal: 5 }),
    ).toBe(0);
  });

  test("strong cards and perfect quizzes approach 1", () => {
    const cards = Array.from({ length: 10 }, () => ({
      easeFactor: 3.0,
      interval: 30,
    }));
    const m = calculateDomainMastery({ cards, quizCorrect: 10, quizTotal: 10 });
    expect(m).toBeCloseTo(1.0, 5);
  });

  test("weights: ease 40%, stability 35%, quiz 25%", () => {
    // avg ease 1.3 → 0; all intervals ≤ 7 → 0; quiz 100% → 0.25
    const cards = [{ easeFactor: 1.3, interval: 1 }];
    expect(
      calculateDomainMastery({ cards, quizCorrect: 4, quizTotal: 4 }),
    ).toBeCloseTo(0.25, 5);
  });
});

describe("adaptive difficulty", () => {
  test("tier from mastery thresholds", () => {
    expect(selectTier({ mastery: 0.1 })).toBe(1);
    expect(selectTier({ mastery: 0.3 })).toBe(2);
    expect(selectTier({ mastery: 0.6 })).toBe(3);
    expect(selectTier({ mastery: 0.8 })).toBe(4);
  });

  test("boss pushes one tier, capped at 4", () => {
    expect(selectTier({ mastery: 0.6, isBoss: true })).toBe(4);
    expect(selectTier({ mastery: 0.9, isBoss: true })).toBe(4);
  });

  test("early chapter caps at intermediate", () => {
    expect(selectTier({ mastery: 0.9, earlyInChapter: true })).toBe(2);
  });

  test("struggling users get easier mix", () => {
    const p = computeSessionProfile({
      recentAccuracy: 0.5,
      overdueCardCount: 0,
      confidenceCalibrationError: 0,
    });
    expect(p.tierRatios[1]).toBe(0.4);
  });

  test("session length recommendation", () => {
    expect(
      recommendSessionLength({ overdueCardCount: 25, currentStreak: 10, isWeekend: true }),
    ).toBe("standard");
    expect(
      recommendSessionLength({ overdueCardCount: 10, currentStreak: 8, isWeekend: true }),
    ).toBe("deep");
    expect(
      recommendSessionLength({ overdueCardCount: 2, currentStreak: 0, isWeekend: false }),
    ).toBe("sprint");
  });
});

describe("session generation", () => {
  const card = (conceptId: string, easeFactor = 2.5) => ({ conceptId, easeFactor });

  test("warmup picks highest ease factor", () => {
    const s = generateSession({
      dueCards: [],
      easyCards: [card("a", 2.0), card("b", 3.0), card("c", 2.5)],
      availableQuestions: [],
      domainOf: () => "rl",
      config: { warmupCards: 2, coreReviewCards: 5, challengeQuestions: 2 },
    });
    expect(s.warmupCards.map((c) => c.conceptId)).toEqual(["b", "c"]);
  });

  test("core interleaves domains", () => {
    const domains: Record<string, string> = {
      a1: "rl", a2: "rl", a3: "rl",
      b1: "perception", b2: "perception",
    };
    const s = generateSession({
      dueCards: [card("a1"), card("a2"), card("a3"), card("b1"), card("b2")],
      easyCards: [],
      availableQuestions: [],
      domainOf: (id) => domains[id],
      config: { warmupCards: 0, coreReviewCards: 4, challengeQuestions: 0 },
    });
    expect(s.coreCards.map((c) => c.conceptId)).toEqual(["a1", "b1", "a2", "b2"]);
  });

  test("challenge prefers questions about reviewed concepts", () => {
    const s = generateSession({
      dueCards: [card("ppo")],
      easyCards: [],
      availableQuestions: [
        { id: "q1", concept_ids: ["sac"] },
        { id: "q2", concept_ids: ["ppo"] },
        { id: "q3", concept_ids: ["mdp"] },
      ],
      domainOf: () => "rl",
      config: { warmupCards: 0, coreReviewCards: 5, challengeQuestions: 2 },
    });
    expect(s.challengeQuestions.map((q) => q.id)).toEqual(["q2", "q1"]);
  });
});

describe("unlock engine (concept-level)", () => {
  const ch = (
    id: string,
    conceptIds: string[],
    prereqs: string[] = [],
  ): ChapterLike => ({
    id,
    concept_ids: conceptIds,
    prerequisite_chapter_ids: prereqs,
  });

  test("chapter with no prereqs is unlocked", () => {
    const c = ch("ch1", ["a", "b"]);
    expect(isChapterUnlocked(c, new Map([["ch1", c]]), {})).toBe(true);
  });

  test("chapter unlocks at 60% of prereq concepts learned (L2+)", () => {
    const ch1 = ch("ch1", ["a", "b", "c", "d", "e"]);
    const ch2 = ch("ch2", ["f"], ["ch1"]);
    const all = new Map([["ch1", ch1], ["ch2", ch2]]);

    expect(isChapterUnlocked(ch2, all, { a: 2, b: 2 })).toBe(false); // 40%
    expect(isChapterUnlocked(ch2, all, { a: 2, b: 2, c: 2 })).toBe(true); // 60%
    expect(isChapterUnlocked(ch2, all, { a: 1, b: 1, c: 1, d: 1, e: 1 })).toBe(
      false, // L1 doesn't count as learned
    );
  });

  test("chapter progress", () => {
    expect(chapterProgress(ch("c", ["a", "b", "c", "d"]), { a: 3, b: 2 })).toBe(0.5);
  });

  test("world unlocks per required completion percent", () => {
    const w1Chapters = [ch("c1", ["a"]), ch("c2", ["b"])];
    const world2 = {
      id: "w2",
      prerequisite_world_ids: ["w1"],
      required_completion_percent: 0.5,
    };
    const byWorld = new Map([["w1", w1Chapters]]);
    expect(isWorldUnlocked(world2, byWorld, { a: 2 })).toBe(true); // 1/2 chapters
    expect(isWorldUnlocked(world2, byWorld, {})).toBe(false);
  });
});

describe("levels & XP", () => {
  test("level pass threshold is 80%", () => {
    expect(isLevelPassed(4, 5)).toBe(true);
    expect(isLevelPassed(3, 5)).toBe(false);
    expect(isLevelPassed(0, 0)).toBe(false);
  });

  test("xp per level", () => {
    expect(xpForLevel(1)).toBe(20);
    expect(xpForLevel(5)).toBe(100);
  });

  test("xp curve is monotonic and starts at level 1", () => {
    expect(cumulativeXpForLevel(1)).toBe(0);
    expect(cumulativeXpForLevel(2)).toBe(100);
    expect(xpStatus(0).level).toBe(1);
    expect(xpStatus(99).level).toBe(1);
    expect(xpStatus(100).level).toBe(2);
    const s = xpStatus(150);
    expect(s.level).toBe(2);
    expect(s.levelXp).toBe(50);
  });
});

describe("streaks", () => {
  const init = { currentStreak: 0, longestStreak: 0, lastSessionDay: null };

  test("first session starts streak at 1", () => {
    const s = updateStreak(init, new Date("2026-06-11T10:00:00"));
    expect(s.currentStreak).toBe(1);
    expect(s.lastSessionDay).toBe("2026-06-11");
  });

  test("consecutive days increment, same day is idempotent", () => {
    let s = updateStreak(init, new Date("2026-06-11T10:00:00"));
    s = updateStreak(s, new Date("2026-06-11T22:00:00"));
    expect(s.currentStreak).toBe(1);
    s = updateStreak(s, new Date("2026-06-12T07:00:00"));
    expect(s.currentStreak).toBe(2);
    expect(s.longestStreak).toBe(2);
  });

  test("gap resets streak but keeps longest", () => {
    let s: StreakState = {
      currentStreak: 5,
      longestStreak: 5,
      lastSessionDay: "2026-06-01",
    };
    s = updateStreak(s, new Date("2026-06-11T10:00:00"));
    expect(s.currentStreak).toBe(1);
    expect(s.longestStreak).toBe(5);
  });

  test("staleness detection", () => {
    expect(
      isStreakStale(
        { currentStreak: 3, longestStreak: 3, lastSessionDay: "2026-06-09" },
        new Date("2026-06-11T10:00:00"),
      ),
    ).toBe(true);
    expect(
      isStreakStale(
        { currentStreak: 3, longestStreak: 3, lastSessionDay: "2026-06-10" },
        new Date("2026-06-11T10:00:00"),
      ),
    ).toBe(false);
  });
});
