/**
 * User XP curve: cumulative XP required to reach user level n is
 * `100 · n^1.5` (level 1 starts at 0).
 */

export type XpStatus = {
  level: number;
  totalXp: number;
  /** XP accumulated within the current level. */
  levelXp: number;
  /** XP span of the current level. */
  levelSpan: number;
  /** 0–1 progress toward the next level. */
  progress: number;
};

export function cumulativeXpForLevel(level: number): number {
  if (level <= 1) return 0;
  return Math.round(100 * Math.pow(level - 1, 1.5));
}

export function xpStatus(totalXp: number): XpStatus {
  let level = 1;
  while (cumulativeXpForLevel(level + 1) <= totalXp) {
    level++;
  }
  const floor = cumulativeXpForLevel(level);
  const ceil = cumulativeXpForLevel(level + 1);
  const levelSpan = ceil - floor;
  const levelXp = totalXp - floor;
  return {
    level,
    totalXp,
    levelXp,
    levelSpan,
    progress: levelSpan > 0 ? levelXp / levelSpan : 0,
  };
}
