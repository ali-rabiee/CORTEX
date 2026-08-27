"use client";

import { LevelRing } from "@/components/level-ring";
import { useConceptProgress } from "@/lib/db/hooks";

/** LevelRing wired to live user progress from IndexedDB. */
export function ConceptRing({
  conceptId,
  color,
  availableLevels,
  size = 44,
  strokeWidth = 4,
}: {
  conceptId: string;
  color: string;
  availableLevels: number[];
  size?: number;
  strokeWidth?: number;
}) {
  const progress = useConceptProgress(conceptId);
  return (
    <LevelRing
      color={color}
      completedLevels={progress?.currentLevel ?? 0}
      availableLevels={availableLevels}
      size={size}
      strokeWidth={strokeWidth}
    />
  );
}
