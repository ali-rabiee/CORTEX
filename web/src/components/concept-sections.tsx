"use client";

import { Check } from "lucide-react";
import { useEffect, useState } from "react";

import { useConceptProgress } from "@/lib/db/hooks";
import { LEVEL_INFO, type Level } from "@/lib/content/schema";

export type SectionItem = { level: Level; slug: string; title: string };

/**
 * Sticky section rail for a concept page.
 *
 * Deliberately navigation, not gating: every section is readable from the
 * moment you open the concept. You often need the interview answer *before*
 * you've ground through the math — locking it behind three checks made the
 * page hostile to the way it actually gets used. Passing checks still records
 * mastery and drives spaced repetition; it just no longer withholds reading.
 */
export function SectionRail({
  sections,
  conceptId,
  color,
}: {
  sections: SectionItem[];
  conceptId: string;
  color: string;
}) {
  const progress = useConceptProgress(conceptId);
  const currentLevel = progress?.currentLevel ?? 0;
  const [active, setActive] = useState<string | null>(sections[0]?.slug ?? null);

  useEffect(() => {
    const targets = sections
      .map((s) => document.getElementById(s.slug))
      .filter((el): el is HTMLElement => el !== null);
    if (targets.length === 0) return;

    const observer = new IntersectionObserver(
      (entries) => {
        // The topmost section currently intersecting wins.
        const visible = entries
          .filter((e) => e.isIntersecting)
          .sort((a, b) => a.boundingClientRect.top - b.boundingClientRect.top);
        if (visible[0]) setActive(visible[0].target.id);
      },
      // Bias the band toward the top of the viewport so the highlight tracks
      // what you're reading, not what's scrolling past the bottom.
      { rootMargin: "-15% 0px -70% 0px", threshold: 0 },
    );

    for (const el of targets) observer.observe(el);
    return () => observer.disconnect();
  }, [sections]);

  return (
    <nav
      aria-label="Sections"
      className="sticky top-0 z-20 -mx-4 mb-10 flex gap-1.5 overflow-x-auto border-b border-border bg-background/92 px-4 py-2.5 backdrop-blur md:-mx-8 md:px-8"
    >
      {sections.map((s) => {
        const isActive = active === s.slug;
        const passed = s.level <= currentLevel;
        return (
          <a
            key={s.slug}
            href={`#${s.slug}`}
            aria-current={isActive ? "true" : undefined}
            className={`flex shrink-0 items-center gap-1.5 rounded-full px-3 py-1.5 text-xs font-medium transition-colors ${
              isActive
                ? "bg-card text-foreground"
                : "text-muted-foreground hover:text-foreground"
            }`}
            style={isActive ? { color } : undefined}
          >
            {passed && <Check size={12} strokeWidth={3} className="text-success" />}
            {s.title}
          </a>
        );
      })}
    </nav>
  );
}

/** Section heading with its mastery state. */
export function SectionHeading({
  level,
  conceptId,
  color,
}: {
  level: Level;
  conceptId: string;
  color: string;
}) {
  const progress = useConceptProgress(conceptId);
  const passed = (progress?.currentLevel ?? 0) >= level;
  const info = LEVEL_INFO[level];

  return (
    <header className="mb-5">
      <div className="flex flex-wrap items-center gap-x-3 gap-y-1">
        <span
          className="text-[0.7rem] font-semibold uppercase tracking-wider"
          style={{ color }}
        >
          Part {level}
        </span>
        {passed && (
          <span className="flex items-center gap-1 text-[0.7rem] font-medium text-success">
            <Check size={12} strokeWidth={3} /> passed
          </span>
        )}
      </div>
      <h2 className="mt-1 text-xl font-bold tracking-tight md:text-2xl">
        {info.title}
      </h2>
      <p className="mt-1 text-sm text-muted-foreground">{info.tagline}</p>
    </header>
  );
}
