"use client";

import {
  CheckCircle2,
  Clock,
  Eye,
  Flame,
  Snowflake,
  Sparkles,
  Trophy,
  Zap,
} from "lucide-react";
import Link from "next/link";
import { useEffect, useState } from "react";

import { MathText } from "@/components/math-text";
import { DomainChip } from "@/components/domain-chip";
import { useDueCardCount, useUserStats } from "@/lib/db/hooks";
import {
  SESSION_LENGTHS,
  type SessionLength,
} from "@/lib/engine/adaptive-difficulty";
import { recallFor, type SessionManifest } from "@/lib/content/manifest";
import { recommendLength, useSessionStore } from "@/stores/session-store";

import { QuizQuestionCard } from "./quiz-question-card";
import { ConfidenceBar, QualityBar } from "./rating-bars";

export function SessionPlayer({ manifest }: { manifest: SessionManifest }) {
  const s = useSessionStore();

  switch (s.phase) {
    case "idle":
      return <SessionIdle manifest={manifest} />;
    case "warmup":
    case "core":
      return <SessionReview manifest={manifest} />;
    case "challenge":
      return <SessionChallenge />;
    case "summary":
      return <SessionSummary />;
  }
}

function SessionIdle({ manifest }: { manifest: SessionManifest }) {
  const start = useSessionStore((s) => s.start);
  const [now] = useState(() => new Date());
  const dueCount = useDueCardCount(now);
  const [recommended, setRecommended] = useState<SessionLength | null>(null);

  useEffect(() => {
    void recommendLength().then(setRecommended);
  }, []);

  return (
    <div className="mx-auto max-w-2xl px-4 py-12 md:px-8">
      <div className="text-center">
        <span className="inline-block rounded-2xl bg-warning/15 p-4 text-warning">
          <Zap size={28} />
        </span>
        <h1 className="mt-4 text-2xl font-bold tracking-tight">Daily session</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          {dueCount === undefined
            ? "Checking your review queue…"
            : dueCount === 0
              ? "No cards due — warmup and quiz only, or come back tomorrow."
              : `${dueCount} card${dueCount === 1 ? "" : "s"} due for review.`}
        </p>
      </div>

      <div className="mt-8 grid gap-3 sm:grid-cols-3">
        {(Object.keys(SESSION_LENGTHS) as SessionLength[]).map((key) => {
          const cfg = SESSION_LENGTHS[key];
          const isRecommended = key === recommended;
          return (
            <button
              key={key}
              onClick={() => void start(manifest, key)}
              className={`relative rounded-card border p-5 text-left transition-all hover:-translate-y-0.5 ${
                isRecommended
                  ? "border-primary/60 bg-primary/10"
                  : "border-border bg-card hover:border-border-strong"
              }`}
            >
              {isRecommended && (
                <span className="absolute -top-2.5 left-4 rounded-full bg-primary px-2 py-0.5 text-[0.65rem] font-bold text-primary-foreground">
                  Recommended
                </span>
              )}
              <p className="font-semibold">{cfg.label}</p>
              <p className="mt-1 flex items-center gap-1 text-xs text-muted-foreground">
                <Clock size={12} /> ~{cfg.minutes} min
              </p>
              <p className="mt-3 text-[0.7rem] leading-relaxed text-faint">
                {cfg.warmupCards} warmup · {cfg.coreReviewCards} reviews ·{" "}
                {cfg.challengeQuestions} quiz
              </p>
            </button>
          );
        })}
      </div>

      <p className="mt-6 text-center text-xs text-faint">
        Haven&apos;t learned anything yet?{" "}
        <Link href="/learn" className="text-primary-light underline">
          Pass a level first
        </Link>{" "}
        — reviews are created when you level up a concept.
      </p>
    </div>
  );
}

function SessionReview({ manifest }: { manifest: SessionManifest }) {
  const s = useSessionStore();
  const card = s.cards[s.cardIndex];
  if (!card) return null;

  const info = manifest.concepts[card.conceptId];
  const recall = recallFor(manifest, card.conceptId, card.level);
  const isWarmup = s.phase === "warmup";

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 md:px-8">
      <SessionProgress />

      <div className="mt-6 rounded-card border border-border bg-card p-6">
        <div className="flex items-center justify-between gap-3">
          <span
            className={`flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wide ${
              isWarmup ? "text-domain-rl" : "text-warning"
            }`}
          >
            {isWarmup ? <Snowflake size={13} /> : <Flame size={13} />}
            {isWarmup ? "Warmup" : "Core review"} · L{card.level}
          </span>
          {info && <DomainChip domain={info.domain} />}
        </div>

        <h2 className="mt-4 text-lg font-semibold leading-snug">
          {info?.title ?? card.conceptId}
        </h2>
        <p className="mt-3 text-[0.95rem] leading-relaxed">
          <MathText
            text={
              recall?.prompt ??
              `Explain ${info?.title ?? card.conceptId} from memory.`
            }
          />
        </p>

        {s.revealed && recall && (
          <div className="mt-5 rounded-lg border border-success/30 bg-success/5 p-4">
            <p className="text-xs font-semibold uppercase tracking-wide text-success">
              Key points
            </p>
            <ul className="mt-2 list-disc space-y-1.5 pl-5 text-sm leading-relaxed">
              {recall.keyPoints.map((kp, i) => (
                <li key={i}>
                  <MathText text={kp} />
                </li>
              ))}
            </ul>
            <Link
              href={`/concepts/${card.conceptId}`}
              className="mt-3 inline-block text-xs text-primary-light underline"
            >
              Open full concept →
            </Link>
          </div>
        )}
      </div>

      <div className="mt-6">
        {!s.revealed ? (
          <div className="space-y-5">
            <ConfidenceBar
              value={s.pendingConfidence}
              onChange={s.rateConfidence}
            />
            <div className="text-center">
              <button
                onClick={s.reveal}
                disabled={s.pendingConfidence === null}
                className="inline-flex items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:cursor-not-allowed disabled:opacity-40"
              >
                <Eye size={15} /> Reveal answer
              </button>
            </div>
          </div>
        ) : (
          <QualityBar onChange={(q) => void s.rateQuality(manifest, q)} />
        )}
      </div>
    </div>
  );
}

function SessionChallenge() {
  const s = useSessionStore();
  const question = s.questions[s.questionIndex];
  const [answered, setAnswered] = useState(false);
  if (!question) return null;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 md:px-8">
      <SessionProgress />
      <div className="mt-6 rounded-card border border-border bg-card p-6">
        <span className="flex items-center gap-1.5 text-xs font-semibold uppercase tracking-wide text-domain-generative">
          <Sparkles size={13} /> Challenge · {s.questionIndex + 1}/
          {s.questions.length}
        </span>
        <div className="mt-4">
          <QuizQuestionCard
            key={question.id}
            question={question}
            domain={question.domain}
            onAnswered={(correct) => {
              s.answerQuiz(correct);
              setAnswered(true);
            }}
          />
        </div>
      </div>
      {answered && (
        <div className="mt-5 text-center">
          <button
            onClick={() => {
              setAnswered(false);
              void s.nextQuestion();
            }}
            className="rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
          >
            {s.questionIndex + 1 < s.questions.length
              ? "Next question"
              : "Finish session"}
          </button>
        </div>
      )}
    </div>
  );
}

function SessionSummary() {
  const s = useSessionStore();
  const stats = useUserStats();
  const accuracy =
    s.questions.length > 0
      ? Math.round((s.quizCorrect / s.questions.length) * 100)
      : null;

  return (
    <div className="mx-auto max-w-md px-4 py-16 text-center md:px-8">
      <span className="inline-block rounded-2xl bg-success/15 p-4 text-success">
        <Trophy size={28} />
      </span>
      <h1 className="mt-4 text-2xl font-bold">Session complete</h1>
      <p className="mt-1 text-sm text-muted-foreground">
        {stats?.currentStreak ? (
          <span className="inline-flex items-center gap-1 font-semibold text-warning">
            <Flame size={14} /> {stats.currentStreak}-day streak
          </span>
        ) : null}
      </p>

      <div className="mt-8 grid grid-cols-3 gap-3 text-sm">
        <SummaryStat label="Reviewed" value={String(s.reviewedCount)} />
        <SummaryStat
          label="Quiz"
          value={accuracy === null ? "—" : `${accuracy}%`}
        />
        <SummaryStat label="XP" value={`+${s.xpEarned}`} />
      </div>

      <div className="mt-8 flex justify-center gap-3">
        <Link
          href="/"
          className="rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
          onClick={() => s.abort()}
        >
          Done
        </Link>
        <Link
          href="/learn"
          className="rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition-colors hover:border-border-strong"
          onClick={() => s.abort()}
        >
          Keep learning
        </Link>
      </div>
    </div>
  );
}

function SummaryStat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-card border border-border bg-card p-4">
      <p className="text-xl font-bold">{value}</p>
      <p className="mt-0.5 text-[0.65rem] uppercase tracking-wide text-faint">
        {label}
      </p>
    </div>
  );
}

function SessionProgress() {
  const s = useSessionStore();
  const totalSteps = s.cards.length + s.questions.length;
  const step =
    s.phase === "challenge" ? s.cards.length + s.questionIndex : s.cardIndex;
  const pct = totalSteps > 0 ? Math.round((step / totalSteps) * 100) : 0;

  return (
    <div className="flex items-center gap-3">
      <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-border">
        <div
          className="h-full rounded-full bg-gradient-to-r from-primary to-primary-light transition-all duration-300"
          style={{ width: `${pct}%` }}
        />
      </div>
      <span className="flex items-center gap-1 text-xs font-medium text-faint">
        <CheckCircle2 size={12} /> {step}/{totalSteps}
      </span>
      <button
        onClick={() => useSessionStore.getState().abort()}
        className="text-xs text-faint underline hover:text-muted-foreground"
      >
        quit
      </button>
    </div>
  );
}
