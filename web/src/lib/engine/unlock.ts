/**
 * Curriculum gating, generalized from the Flutter app's mission-based
 * `unlock_engine.dart` to the web app's concept-level model:
 *
 * - A concept counts as "learned" once the user passes its L2 (math) check.
 * - A chapter unlocks when every prerequisite chapter has ≥ 60% of its
 *   concepts learned.
 * - A world unlocks when every prerequisite world has ≥
 *   `required_completion_percent` of its chapters completed (a chapter is
 *   complete when ≥ 60% of its concepts are learned).
 */

export const LEARNED_LEVEL = 2;
export const CHAPTER_COMPLETION_THRESHOLD = 0.6;

export type ConceptLevelMap = Record<string, number | undefined>;

export type ChapterLike = {
  id: string;
  prerequisite_chapter_ids: string[];
  concept_ids: string[];
};

export type WorldLike = {
  id: string;
  prerequisite_world_ids: string[];
  required_completion_percent: number;
};

/** Fraction of a chapter's concepts the user has learned (L2+). */
export function chapterProgress(
  chapter: ChapterLike,
  levels: ConceptLevelMap,
): number {
  if (chapter.concept_ids.length === 0) return 0;
  const learned = chapter.concept_ids.filter(
    (id) => (levels[id] ?? 0) >= LEARNED_LEVEL,
  ).length;
  return learned / chapter.concept_ids.length;
}

export function isChapterComplete(
  chapter: ChapterLike,
  levels: ConceptLevelMap,
): boolean {
  return (
    chapter.concept_ids.length > 0 &&
    chapterProgress(chapter, levels) >= CHAPTER_COMPLETION_THRESHOLD
  );
}

export function isChapterUnlocked(
  chapter: ChapterLike,
  allChapters: Map<string, ChapterLike>,
  levels: ConceptLevelMap,
): boolean {
  return chapter.prerequisite_chapter_ids.every((prereqId) => {
    const prereq = allChapters.get(prereqId);
    if (!prereq || prereq.concept_ids.length === 0) return true;
    return isChapterComplete(prereq, levels);
  });
}

/** Average chapter progress across a world's chapters. */
export function worldProgress(
  worldChapters: ChapterLike[],
  levels: ConceptLevelMap,
): number {
  if (worldChapters.length === 0) return 0;
  const total = worldChapters.reduce(
    (sum, ch) => sum + chapterProgress(ch, levels),
    0,
  );
  return total / worldChapters.length;
}

export function isWorldUnlocked(
  world: WorldLike,
  chaptersByWorld: Map<string, ChapterLike[]>,
  levels: ConceptLevelMap,
): boolean {
  return world.prerequisite_world_ids.every((prereqId) => {
    const prereqChapters = chaptersByWorld.get(prereqId) ?? [];
    if (prereqChapters.length === 0) return true;
    const completed = prereqChapters.filter((ch) =>
      isChapterComplete(ch, levels),
    ).length;
    return (
      completed / prereqChapters.length >= world.required_completion_percent
    );
  });
}
