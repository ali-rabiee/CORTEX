"use client";

import { Flame } from "lucide-react";

import { useUserStats, useXpStatus } from "@/lib/db/hooks";

/** Sidebar XP + streak summary, live from IndexedDB. */
export function XpBadge() {
  const xp = useXpStatus();
  const stats = useUserStats();

  if (xp === undefined) {
    return (
      <div className="mb-6 h-16 animate-pulse rounded-card border border-border bg-card" />
    );
  }

  return (
    <div className="mb-6 rounded-card border border-border bg-card p-3">
      <div className="flex items-center justify-between text-xs">
        <span className="font-bold text-primary-light">Lv {xp.level}</span>
        <span className="flex items-center gap-1 font-semibold text-warning">
          <Flame size={13} />
          {stats?.currentStreak ?? 0}
        </span>
      </div>
      <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-border">
        <div
          className="h-full rounded-full bg-gradient-to-r from-primary to-primary-light transition-all duration-500"
          style={{ width: `${Math.round(xp.progress * 100)}%` }}
        />
      </div>
      <p className="mt-1.5 text-[0.65rem] text-faint">
        {xp.levelXp}/{xp.levelSpan} XP to level {xp.level + 1}
      </p>
    </div>
  );
}
