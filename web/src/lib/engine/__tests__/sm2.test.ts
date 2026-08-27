import { describe, expect, test } from "vitest";

import { calculateSm2 } from "../sm2";

/** The 6 cases ported from app/test/domain/usecases/sm2_algorithm_test.dart. */
describe("SM-2 algorithm (Dart parity)", () => {
  test("successful recall with quality 5 increases interval", () => {
    const result = calculateSm2({
      quality: 5,
      easeFactor: 2.5,
      interval: 1,
      repetitions: 0,
    });
    expect(result.interval).toBe(1);
    expect(result.repetitions).toBe(1);
    expect(result.easeFactor).toBeGreaterThan(2.5);
  });

  test("second successful recall sets interval to 6", () => {
    const result = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 1,
      repetitions: 1,
    });
    expect(result.interval).toBe(6);
    expect(result.repetitions).toBe(2);
  });

  test("third successful recall multiplies interval by ease factor", () => {
    const result = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 6,
      repetitions: 2,
    });
    expect(result.interval).toBe(15); // round(6 * 2.5)
    expect(result.repetitions).toBe(3);
  });

  test("failed recall resets interval and repetitions", () => {
    const result = calculateSm2({
      quality: 2,
      easeFactor: 2.5,
      interval: 15,
      repetitions: 5,
    });
    expect(result.interval).toBe(1);
    expect(result.repetitions).toBe(0);
  });

  test("ease factor never drops below 1.3", () => {
    const result = calculateSm2({
      quality: 0,
      easeFactor: 1.3,
      interval: 1,
      repetitions: 0,
    });
    expect(result.easeFactor).toBe(1.3);
  });

  test("overconfidence rate reduces interval", () => {
    const without = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 6,
      repetitions: 2,
    });
    const withCalibration = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 6,
      repetitions: 2,
      overconfidenceRate: 0.5,
    });
    expect(withCalibration.interval).toBeLessThan(without.interval);
  });
});

describe("SM-2 algorithm (web additions)", () => {
  test("overconfidence rate exactly 0.3 does not reduce interval", () => {
    const result = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 6,
      repetitions: 2,
      overconfidenceRate: 0.3,
    });
    expect(result.interval).toBe(15);
  });

  test("interval floor is 1 even after heavy reduction", () => {
    const result = calculateSm2({
      quality: 3,
      easeFactor: 1.3,
      interval: 1,
      repetitions: 0,
      overconfidenceRate: 1.0,
    });
    expect(result.interval).toBe(1);
  });

  test("nextReviewDate is interval days ahead at UTC midnight", () => {
    const now = new Date("2026-06-11T15:30:00Z");
    const result = calculateSm2({
      quality: 4,
      easeFactor: 2.5,
      interval: 1,
      repetitions: 1,
      now,
    });
    expect(result.nextReviewDate).toBe("2026-06-17T00:00:00.000Z");
  });

  test("quality 3 boundary counts as success", () => {
    const result = calculateSm2({
      quality: 3,
      easeFactor: 2.5,
      interval: 6,
      repetitions: 2,
    });
    expect(result.repetitions).toBe(3);
    expect(result.interval).toBe(15);
  });
});
