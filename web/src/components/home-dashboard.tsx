"use client";

import { useLiveQuery } from "dexie-react-hooks";
import {
  AlertTriangle,
  ArrowRight,
  BookOpen,
  Flame,
  Zap,
} from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { db } from "@/lib/db/db";
import { useUserStats, useXpStatus } from "@/lib/db/hooks";
import { isStreakStale } from "@/lib/engine/streak";
import { DOMAIN_HEX } from "@/lib/domains";
import type { SessionManifest } from "@/lib/content/manifest";

/** Live widgets at the top of the home page once the user has any progress. */
export function HomeDashboard({ manifest }: { manifest: SessionManifest }) {
  const [now] = useState(() => new Date());
  const stats = useUserStats();
  const xp = useXpStatus();

  const reviewState = useLiveQuery(async () => {
    const cards = await db.reviewCards.toArray();
    const nowIso = now.toISOString();
    const due = cards.filter((c) => c.nextReviewDate <= nowIso);
    const atRisk = cards
      .filter((c) => c.easeFactor < 1.8 || c.nextReviewDate <= nowIso)
      .sort((a, b) => a.easeFactor - b.easeFactor)
      .slice(0, 5);
    return { total: cards.length, due: due.length, atRisk };
  }, [now.toISOString()]);

  const continueConcept = useLiveQuery(async () => {
    const rows = await db.conceptProgress
      .filter((p) => p.currentLevel > 0)
      .toArray();
    let best: { conceptId: string; at: string; level: number } | null = null;
    for (const row of rows) {
      const max = Math.max(
        ...manifest.concepts[row.conceptId]?.availableLevels ?? [5],
      );
      if (row.currentLevel >= max) continue; // fully done for now
      const at = row.levelPassedAt[row.currentLevel] ?? "";
      if (!best || at > best.at) {
        best = { conceptId: row.conceptId, at, level: row.currentLevel };
      }
    }
    return best;
  }, []);

  if (reviewState === undefined || stats === undefined) return null;
  const hasProgress = reviewState.total > 0 || (stats?.totalSessions ?? 0) > 0;
  if (!hasProgress) return null;

  const streakBroken = stats !== null && isStreakStale(stats, now);

  return (
    <div className="mb-8 space-y-4">
      {/* Session CTA */}
      <div className="flex flex-col gap-4 rounded-card border border-border bg-gradient-to-br from-surface to-card p-6 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-lg font-bold">
            {reviewState.due > 0
              ? `${reviewState.due} card${reviewState.due === 1 ? "" : "s"} due today`
              : "All caught up"}
          </h2>
          <p className="mt-1 flex items-center gap-3 text-sm text-muted-foreground">
            <span
              className={`inline-flex items-center gap-1 font-semibold ${
                streakBroken ? "text-faint" : "text-warning"
              }`}
            >
              <Flame size={14} />
              {stats?.currentStreak ?? 0}-day streak
              {streakBroken && " (at risk)"}
            </span>
            {xp && <span>Level {xp.level}</span>}
          </p>
        </div>
        <Link
          href="/session"
          className="inline-flex shrink-0 items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
        >
          <Zap size={16} /> Start session
        </Link>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        {/* Continue learning */}
        {continueConcept && manifest.concepts[continueConcept.conceptId] && (
          <Link
            href={`/concepts/${continueConcept.conceptId}`}
            className="group rounded-card border border-border bg-card p-5 transition-all hover:-translate-y-0.5 hover:border-border-strong"
          >
            <p className="flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
              <BookOpen size={13} /> Continue learning
            </p>
            <p className="mt-2 font-semibold group-hover:text-primary-light">
              {manifest.concepts[continueConcept.conceptId].title}
            </p>
            <p className="mt-1 inline-flex items-center gap-1 text-xs text-faint">
              Level {continueConcept.level} passed — next up: L
              {(manifest.concepts[continueConcept.conceptId].availableLevels.find(
                (l) => l > continueConcept.level,
              )) ?? continueConcept.level + 1}
              <ArrowRight size={11} />
            </p>
          </Link>
        )}

        {/* At-risk concepts */}
        {reviewState.atRisk.length > 0 && (
          <div className="rounded-card border border-border bg-card p-5">
            <p className="flex items-center gap-2 text-xs font-semibold uppercase tracking-wide text-warning">
              <AlertTriangle size={13} /> Needs attention
            </p>
            <ul className="mt-2 space-y-1.5">
              {reviewState.atRisk.map((card) => {
                const info = manifest.concepts[card.conceptId];
                if (!info) return null;
                return (
                  <li key={card.conceptId}>
                    <Link
                      href={`/concepts/${card.conceptId}`}
                      className="flex items-center gap-2 text-sm text-muted-foreground transition-colors hover:text-foreground"
                    >
                      <span
                        className="size-1.5 shrink-0 rounded-full"
                        style={{ background: DOMAIN_HEX[info.domain] }}
                      />
                      <span className="truncate">{info.title}</span>
                      <span className="ml-auto shrink-0 text-[0.65rem] text-faint">
                        ease {card.easeFactor.toFixed(1)}
                      </span>
                    </Link>
                  </li>
                );
              })}
            </ul>
          </div>
        )}
      </div>
    </div>
  );
}
