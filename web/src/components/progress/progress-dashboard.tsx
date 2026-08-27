"use client";

import { useLiveQuery } from "dexie-react-hooks";
import { BarChart3, Brain, Calendar, Scale } from "lucide-react";
import {
  PolarAngleAxis,
  PolarGrid,
  Radar,
  RadarChart,
  ResponsiveContainer,
} from "recharts";

import { db } from "@/lib/db/db";
import { analyzeCalibration } from "@/lib/engine/confidence-calibration";
import { calculateDomainMastery } from "@/lib/engine/mastery";
import { localDayKey } from "@/lib/engine/time";
import { DOMAIN_LABELS, DOMAINS, LEVEL_INFO, type Level } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";
import type { SessionManifest } from "@/lib/content/manifest";

export function ProgressDashboard({ manifest }: { manifest: SessionManifest }) {
  const data = useLiveQuery(async () => {
    const [cards, attempts, logs, progress] = await Promise.all([
      db.reviewCards.toArray(),
      db.quizAttempts.toArray(),
      db.confidenceLogs.toArray(),
      db.conceptProgress.toArray(),
    ]);
    return { cards, attempts, logs, progress };
  }, []);

  if (data === undefined) {
    return (
      <div className="space-y-4">
        {[0, 1].map((i) => (
          <div key={i} className="h-48 animate-pulse rounded-card border border-border bg-card" />
        ))}
      </div>
    );
  }

  const { cards, attempts, logs, progress } = data;

  if (cards.length === 0 && attempts.length === 0) {
    return (
      <div className="rounded-card border border-border bg-card p-10 text-center">
        <Brain size={28} className="mx-auto text-faint" />
        <p className="mt-3 font-semibold">No data yet</p>
        <p className="mt-1 text-sm text-muted-foreground">
          Pass a few concept levels and run a daily session — your mastery
          picture builds from there.
        </p>
      </div>
    );
  }

  // ----- domain mastery -----
  const domainOf = (conceptId: string) =>
    manifest.concepts[conceptId]?.domain ?? null;

  const masteryByDomain = DOMAINS.map((domain) => {
    const domainCards = cards.filter((c) => domainOf(c.conceptId) === domain);
    const domainAttempts = attempts.filter((a) => a.domain === domain);
    return {
      domain,
      label: DOMAIN_LABELS[domain],
      mastery: calculateDomainMastery({
        cards: domainCards,
        quizCorrect: domainAttempts.filter((a) => a.correct).length,
        quizTotal: domainAttempts.length,
      }),
      cardCount: domainCards.length,
    };
  });

  const radarData = masteryByDomain.map((d) => ({
    label: d.label.replace(" ", " "),
    mastery: Math.round(d.mastery * 100),
  }));

  // ----- calibration -----
  const calibration = analyzeCalibration(logs);

  // ----- review heatmap (last 12 weeks) -----
  const reviewsByDay = new Map<string, number>();
  for (const log of logs) {
    const day = localDayKey(new Date(log.timestamp));
    reviewsByDay.set(day, (reviewsByDay.get(day) ?? 0) + 1);
  }
  const today = new Date();
  const weeks: Array<Array<{ day: string; count: number }>> = [];
  // Align so the last column is the current week.
  const start = new Date(today);
  start.setDate(start.getDate() - start.getDay() - 11 * 7);
  for (let w = 0; w < 12; w++) {
    const week: Array<{ day: string; count: number }> = [];
    for (let d = 0; d < 7; d++) {
      const date = new Date(start);
      date.setDate(start.getDate() + w * 7 + d);
      if (date > today) break;
      const key = localDayKey(date);
      week.push({ day: key, count: reviewsByDay.get(key) ?? 0 });
    }
    weeks.push(week);
  }
  const maxCount = Math.max(1, ...[...reviewsByDay.values()]);

  // ----- level distribution -----
  const totalConcepts = Object.keys(manifest.concepts).length;
  const levelCounts = new Map<number, number>();
  for (const p of progress) {
    if (p.currentLevel > 0) {
      levelCounts.set(p.currentLevel, (levelCounts.get(p.currentLevel) ?? 0) + 1);
    }
  }
  const started = progress.filter((p) => p.currentLevel > 0).length;

  return (
    <div className="space-y-6">
      {/* Domain mastery */}
      <section className="rounded-card border border-border bg-card p-6">
        <h2 className="flex items-center gap-2 text-sm font-semibold text-muted-foreground">
          <Brain size={15} /> Domain mastery
        </h2>
        <div className="mt-4 grid items-center gap-6 lg:grid-cols-2">
          <div className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <RadarChart data={radarData} outerRadius="75%">
                <PolarGrid stroke="var(--color-border)" />
                <PolarAngleAxis
                  dataKey="label"
                  tick={{ fill: "var(--color-muted-foreground)", fontSize: 10 }}
                />
                <Radar
                  dataKey="mastery"
                  stroke="var(--color-primary)"
                  fill="var(--color-primary)"
                  fillOpacity={0.25}
                />
              </RadarChart>
            </ResponsiveContainer>
          </div>
          <div className="space-y-2.5">
            {masteryByDomain.map((d) => (
              <div key={d.domain}>
                <div className="flex items-baseline justify-between text-xs">
                  <span className="font-medium">{d.label}</span>
                  <span className="text-faint">
                    {d.cardCount > 0
                      ? `${Math.round(d.mastery * 100)}%`
                      : "not started"}
                  </span>
                </div>
                <div className="mt-1 h-1.5 overflow-hidden rounded-full bg-border">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${Math.max(2, d.mastery * 100)}%`,
                      background: DOMAIN_HEX[d.domain],
                      opacity: d.cardCount > 0 ? 1 : 0.15,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Calibration */}
        <section className="rounded-card border border-border bg-card p-6">
          <h2 className="flex items-center gap-2 text-sm font-semibold text-muted-foreground">
            <Scale size={15} /> Confidence calibration
          </h2>
          {logs.length < 5 ? (
            <p className="mt-3 text-sm text-faint">
              Run a few review sessions to measure how well your confidence
              predicts your recall.
            </p>
          ) : (
            <>
              <p
                className={`mt-3 text-lg font-bold ${
                  calibration.isOverconfident
                    ? "text-warning"
                    : calibration.isUnderconfident
                      ? "text-domain-rl"
                      : "text-success"
                }`}
              >
                {calibration.isOverconfident
                  ? "Overconfident"
                  : calibration.isUnderconfident
                    ? "Underconfident"
                    : "Well calibrated"}
              </p>
              <p className="mt-1 text-xs text-muted-foreground">
                ratio {calibration.calibrationRatio.toFixed(2)} (1.0 = perfect).
                {calibration.isOverconfident &&
                  " Review intervals are being shortened to compensate."}
              </p>
              <div className="mt-4 grid grid-cols-2 gap-3 text-sm">
                <div className="rounded-lg bg-surface p-3">
                  <p className="text-[0.65rem] uppercase tracking-wide text-faint">
                    When confident (4–5)
                  </p>
                  <p className="mt-0.5 text-lg font-bold">
                    {Math.round(calibration.highConfidenceAccuracy * 100)}%
                    <span className="ml-1 text-xs font-normal text-faint">correct</span>
                  </p>
                </div>
                <div className="rounded-lg bg-surface p-3">
                  <p className="text-[0.65rem] uppercase tracking-wide text-faint">
                    When unsure (1–2)
                  </p>
                  <p className="mt-0.5 text-lg font-bold">
                    {Math.round(calibration.lowConfidenceAccuracy * 100)}%
                    <span className="ml-1 text-xs font-normal text-faint">correct</span>
                  </p>
                </div>
              </div>
            </>
          )}
        </section>

        {/* Level distribution */}
        <section className="rounded-card border border-border bg-card p-6">
          <h2 className="flex items-center gap-2 text-sm font-semibold text-muted-foreground">
            <BarChart3 size={15} /> Concept levels
          </h2>
          <p className="mt-3 text-sm text-muted-foreground">
            <span className="text-lg font-bold text-foreground">{started}</span>{" "}
            of {totalConcepts} concepts started
          </p>
          <div className="mt-4 space-y-2">
            {( [1, 2, 3, 4, 5] as Level[]).map((level) => {
              const count = levelCounts.get(level) ?? 0;
              return (
                <div key={level} className="flex items-center gap-3 text-xs">
                  <span className="w-20 shrink-0 font-medium">
                    L{level} {LEVEL_INFO[level].title}
                  </span>
                  <div className="h-4 flex-1 overflow-hidden rounded bg-surface">
                    <div
                      className="h-full rounded bg-gradient-to-r from-primary-dark to-primary-light"
                      style={{
                        width: `${started > 0 ? (count / Math.max(started, 1)) * 100 : 0}%`,
                      }}
                    />
                  </div>
                  <span className="w-6 shrink-0 text-right text-faint">{count}</span>
                </div>
              );
            })}
          </div>
        </section>
      </div>

      {/* Review heatmap */}
      <section className="rounded-card border border-border bg-card p-6">
        <h2 className="flex items-center gap-2 text-sm font-semibold text-muted-foreground">
          <Calendar size={15} /> Review activity · last 12 weeks
        </h2>
        <div className="mt-4 flex gap-1 overflow-x-auto pb-1">
          {weeks.map((week, wi) => (
            <div key={wi} className="flex flex-col gap-1">
              {week.map(({ day, count }) => (
                <div
                  key={day}
                  title={`${day}: ${count} review${count === 1 ? "" : "s"}`}
                  className="size-3.5 rounded-[3px]"
                  style={{
                    background:
                      count === 0
                        ? "var(--color-surface)"
                        : `color-mix(in srgb, var(--color-primary) ${
                            25 + (count / maxCount) * 75
                          }%, var(--color-surface))`,
                  }}
                />
              ))}
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
