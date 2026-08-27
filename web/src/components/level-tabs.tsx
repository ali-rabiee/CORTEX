"use client";

import { Hammer, Lock } from "lucide-react";
import { useEffect, useRef, useState, type ReactNode } from "react";

import { useConceptProgress } from "@/lib/db/hooks";
import { LEVEL_INFO, LEVELS, type Level } from "@/lib/content/schema";

export type LevelTabItem = {
  level: Level;
  status: "seed" | "draft" | "final";
};

/**
 * L1–L5 tab rail for a concept page. Receives the server-rendered MDX panels
 * (aligned with `items`) and toggles visibility client-side, so every level
 * stays statically prerendered.
 *
 * Gating: a level is open if the user has passed it, or it is the next
 * authored level above their current one. Higher levels show a lock.
 */
export function LevelTabs({
  conceptId,
  items,
  color,
  panels,
}: {
  conceptId: string;
  /** Authored levels, sorted ascending. */
  items: LevelTabItem[];
  /** Domain accent color (hex). */
  color: string;
  panels: ReactNode[];
}) {
  const progress = useConceptProgress(conceptId);
  const currentLevel = progress?.currentLevel ?? 0;

  const nextAuthored = items.find((i) => i.level > currentLevel)?.level;
  const isOpen = (level: Level) =>
    level <= currentLevel || level === nextAuthored;

  const [active, setActive] = useState<Level>(items[0]?.level ?? 1);
  const prevLevel = useRef<number | null>(null);

  // Follow progression: land returning users on their next open level, and
  // advance the tab automatically when a level is passed.
  useEffect(() => {
    if (progress === undefined) return;
    const next = nextAuthored ?? items.at(-1)?.level;
    if (prevLevel.current === null) {
      if (currentLevel > 0 && next) setActive(next);
    } else if (currentLevel > prevLevel.current && next) {
      setActive(next);
    } else if (!isOpen(active)) {
      const fallback =
        items.filter((i) => isOpen(i.level)).at(-1)?.level ?? items[0]?.level;
      if (fallback) setActive(fallback);
    }
    prevLevel.current = currentLevel;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [currentLevel, progress === undefined]);

  const activeIndex = items.findIndex((i) => i.level === active);

  return (
    <div>
      <div
        role="tablist"
        aria-label="Mastery levels"
        className="flex gap-1.5 overflow-x-auto rounded-card border border-border bg-surface/60 p-1.5"
      >
        {LEVELS.map((level) => {
          const item = items.find((i) => i.level === level);
          const info = LEVEL_INFO[level];
          const isActive = level === active;

          if (!item) {
            return (
              <div
                key={level}
                className="flex min-w-24 flex-1 cursor-not-allowed flex-col items-start gap-0.5 rounded-lg px-3 py-2 opacity-40"
                title="Content coming soon"
              >
                <span className="flex items-center gap-1.5 text-[0.7rem] font-semibold uppercase tracking-wide text-faint">
                  L{level} <Hammer size={11} />
                </span>
                <span className="text-sm font-medium text-faint">
                  {info.title}
                </span>
              </div>
            );
          }

          const open = isOpen(level);
          const passed = level <= currentLevel;

          if (!open) {
            return (
              <div
                key={level}
                className="flex min-w-24 flex-1 cursor-not-allowed flex-col items-start gap-0.5 rounded-lg px-3 py-2 opacity-50"
                title={`Pass level ${nextAuthored} to unlock`}
              >
                <span className="flex items-center gap-1.5 text-[0.7rem] font-semibold uppercase tracking-wide text-faint">
                  L{level} <Lock size={11} />
                </span>
                <span className="text-sm font-medium text-faint">
                  {info.title}
                </span>
              </div>
            );
          }

          return (
            <button
              key={level}
              role="tab"
              aria-selected={isActive}
              onClick={() => setActive(level)}
              className={`flex min-w-24 flex-1 flex-col items-start gap-0.5 rounded-lg px-3 py-2 text-left transition-colors ${
                isActive ? "bg-card shadow-sm" : "hover:bg-card/50"
              }`}
              style={
                isActive ? { boxShadow: `inset 0 0 0 1px ${color}55` } : undefined
              }
            >
              <span
                className="flex items-center gap-1.5 text-[0.7rem] font-semibold uppercase tracking-wide"
                style={{ color: isActive || passed ? color : "var(--color-faint)" }}
              >
                L{level}
                {passed && <span aria-label="passed">✓</span>}
                {item.status !== "final" && (
                  <span className="font-normal normal-case text-faint">
                    {item.status}
                  </span>
                )}
              </span>
              <span
                className={`text-sm font-medium ${
                  isActive ? "text-foreground" : "text-muted-foreground"
                }`}
              >
                {info.title}
              </span>
            </button>
          );
        })}
      </div>

      <p className="mt-3 px-1 text-xs text-faint">{LEVEL_INFO[active].tagline}</p>

      <div className="mt-4">
        {panels.map((panel, i) => (
          <div key={items[i].level} hidden={i !== activeIndex}>
            {panel}
          </div>
        ))}
      </div>
    </div>
  );
}
