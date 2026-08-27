"use client";

import {
  ChevronDown,
  Lock,
  Map as MapIcon,
  Trophy,
} from "lucide-react";
import Link from "next/link";
import { useMemo, useState } from "react";

import { ConceptRing } from "@/components/concept-ring";
import { useAllConceptLevels } from "@/lib/db/hooks";
import {
  chapterProgress,
  isChapterComplete,
  isChapterUnlocked,
  isWorldUnlocked,
  worldProgress,
} from "@/lib/engine/unlock";
import { DOMAIN_HEX } from "@/lib/domains";
import type { Chapter, World } from "@/lib/content/schema";
import type { ConceptInfo } from "@/lib/content/manifest";

/**
 * The campaign view: 6 worlds as a vertical journey, chapters as expandable
 * nodes gated by the unlock engine, concepts wearing their level rings.
 */
export function CurriculumPath({
  worlds,
  chapters,
  concepts,
}: {
  worlds: World[];
  chapters: Chapter[];
  concepts: Record<string, ConceptInfo>;
}) {
  const levels = useAllConceptLevels();

  const { chaptersByWorld, chapterMap } = useMemo(() => {
    const byWorld = new Map<string, Chapter[]>();
    for (const ch of [...chapters].sort((a, b) => a.order_index - b.order_index)) {
      const list = byWorld.get(ch.world_id) ?? [];
      list.push(ch);
      byWorld.set(ch.world_id, list);
    }
    return {
      chaptersByWorld: byWorld,
      chapterMap: new Map(chapters.map((c) => [c.id, c])),
    };
  }, [chapters]);

  if (levels === undefined) {
    return (
      <div className="space-y-4">
        {[0, 1, 2].map((i) => (
          <div
            key={i}
            className="h-28 animate-pulse rounded-card border border-border bg-card"
          />
        ))}
      </div>
    );
  }

  const sortedWorlds = [...worlds].sort((a, b) => a.order_index - b.order_index);

  return (
    <div className="space-y-8">
      {sortedWorlds.map((world, wi) => {
        const worldChapters = chaptersByWorld.get(world.id) ?? [];
        const unlocked = isWorldUnlocked(world, chaptersByWorld, levels);
        const progress = worldProgress(worldChapters, levels);

        return (
          <section
            key={world.id}
            className={unlocked ? "" : "opacity-55 saturate-50"}
          >
            <div className="flex items-start gap-4">
              <div
                className={`flex size-11 shrink-0 items-center justify-center rounded-xl border text-sm font-bold ${
                  unlocked
                    ? "border-primary/50 bg-primary/15 text-primary-light"
                    : "border-border bg-card text-faint"
                }`}
              >
                {unlocked ? wi + 1 : <Lock size={15} />}
              </div>
              <div className="min-w-0 flex-1">
                <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
                  <h2 className="text-lg font-bold tracking-tight">
                    {world.title}
                  </h2>
                  <span className="text-xs font-semibold text-muted-foreground">
                    {Math.round(progress * 100)}%
                  </span>
                </div>
                <p className="mt-0.5 text-sm text-muted-foreground">
                  {world.description}
                </p>
                {!unlocked && (
                  <p className="mt-1 flex items-center gap-1.5 text-xs text-warning">
                    <Lock size={11} />
                    Unlocks at{" "}
                    {Math.round(world.required_completion_percent * 100)}% of
                    the previous world
                  </p>
                )}

                <div className="mt-4 space-y-2.5 border-l border-border pl-5">
                  {worldChapters.map((chapter) => (
                    <ChapterNode
                      key={chapter.id}
                      chapter={chapter}
                      chapterMap={chapterMap}
                      concepts={concepts}
                      levels={levels}
                      worldUnlocked={unlocked}
                    />
                  ))}
                </div>
              </div>
            </div>
          </section>
        );
      })}
    </div>
  );
}

function ChapterNode({
  chapter,
  chapterMap,
  concepts,
  levels,
  worldUnlocked,
}: {
  chapter: Chapter;
  chapterMap: Map<string, Chapter>;
  concepts: Record<string, ConceptInfo>;
  levels: Record<string, number>;
  worldUnlocked: boolean;
}) {
  const [open, setOpen] = useState(false);
  const unlocked = worldUnlocked && isChapterUnlocked(chapter, chapterMap, levels);
  const progress = chapterProgress(chapter, levels);
  const complete = isChapterComplete(chapter, levels);
  const chapterConcepts = chapter.concept_ids
    .map((id) => concepts[id])
    .filter((c): c is ConceptInfo => c !== undefined);

  const prereqTitles = chapter.prerequisite_chapter_ids
    .map((id) => chapterMap.get(id)?.title)
    .filter(Boolean)
    .join(", ");

  if (!unlocked) {
    return (
      <div className="flex items-center gap-3 rounded-card border border-border/60 bg-card/50 px-4 py-3">
        <Lock size={14} className="shrink-0 text-faint" />
        <div className="min-w-0">
          <p className="truncate text-sm font-medium text-faint">
            {chapter.title}
          </p>
          {prereqTitles && worldUnlocked && (
            <p className="truncate text-[0.7rem] text-faint">
              Learn 60% of: {prereqTitles}
            </p>
          )}
        </div>
      </div>
    );
  }

  return (
    <div className="rounded-card border border-border bg-card transition-colors hover:border-border-strong">
      <button
        onClick={() => setOpen((o) => !o)}
        className="flex w-full items-center gap-3 px-4 py-3 text-left"
      >
        <div className="relative size-8 shrink-0">
          <svg viewBox="0 0 32 32" className="size-8 -rotate-90">
            <circle
              cx="16"
              cy="16"
              r="13"
              fill="none"
              stroke="var(--color-border)"
              strokeWidth="3.5"
            />
            <circle
              cx="16"
              cy="16"
              r="13"
              fill="none"
              stroke={complete ? "var(--color-success)" : "var(--color-primary)"}
              strokeWidth="3.5"
              strokeLinecap="round"
              strokeDasharray={`${progress * 81.7} 81.7`}
            />
          </svg>
          {complete && (
            <Trophy
              size={12}
              className="absolute inset-0 m-auto text-success"
            />
          )}
        </div>
        <div className="min-w-0 flex-1">
          <p className="truncate text-sm font-semibold">{chapter.title}</p>
          <p className="truncate text-[0.7rem] text-muted-foreground">
            {chapter.description}
          </p>
        </div>
        <span className="shrink-0 text-[0.7rem] font-medium text-faint">
          {chapterConcepts.length} concepts
        </span>
        <ChevronDown
          size={15}
          className={`shrink-0 text-faint transition-transform ${open ? "rotate-180" : ""}`}
        />
      </button>

      {open && (
        <div className="grid gap-2 border-t border-border p-3 sm:grid-cols-2">
          {chapterConcepts.length === 0 && (
            <p className="flex items-center gap-2 p-2 text-xs text-faint">
              <MapIcon size={13} /> Concepts for this chapter are being mapped.
            </p>
          )}
          {chapterConcepts.map((concept) => (
            <Link
              key={concept.id}
              href={`/concepts/${concept.id}`}
              className="group flex items-center gap-3 rounded-lg border border-border bg-surface px-3 py-2.5 transition-colors hover:border-border-strong"
            >
              <ConceptRing
                conceptId={concept.id}
                color={DOMAIN_HEX[concept.domain]}
                availableLevels={concept.availableLevels}
                size={32}
                strokeWidth={3}
              />
              <span className="truncate text-sm font-medium group-hover:text-primary-light">
                {concept.title}
              </span>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
