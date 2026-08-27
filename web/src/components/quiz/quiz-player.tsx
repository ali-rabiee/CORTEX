"use client";

import { ListChecks, RotateCcw, Trophy } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { QuizQuestionCard } from "@/components/session/quiz-question-card";
import { db } from "@/lib/db/db";
import {
  computeSessionProfile,
  type DifficultyTier,
} from "@/lib/engine/adaptive-difficulty";
import { DOMAIN_LABELS, DOMAINS, type Domain } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";
import type { SessionManifest } from "@/lib/content/manifest";

const QUIZ_SIZE = 10;

type QuizQuestionWithDomain = SessionManifest["questions"][number];

type QuizState =
  | { stage: "pick" }
  | {
      stage: "run";
      domain: Domain | "mixed";
      questions: QuizQuestionWithDomain[];
      index: number;
      correct: number;
      answered: boolean;
    }
  | {
      stage: "done";
      domain: Domain | "mixed";
      total: number;
      correct: number;
    };

export function QuizPlayer({ manifest }: { manifest: SessionManifest }) {
  const [state, setState] = useState<QuizState>({ stage: "pick" });

  const startQuiz = async (domain: Domain | "mixed") => {
    const questions = await sampleQuestions(manifest.questions, domain);
    setState({
      stage: "run",
      domain,
      questions,
      index: 0,
      correct: 0,
      answered: false,
    });
  };

  if (state.stage === "pick") {
    const counts = new Map<Domain, number>();
    for (const q of manifest.questions) {
      counts.set(q.domain, (counts.get(q.domain) ?? 0) + 1);
    }
    return (
      <div className="mx-auto max-w-3xl px-4 py-10 md:px-8">
        <div className="text-center">
          <span className="inline-block rounded-2xl bg-domain-generative/15 p-4 text-domain-generative">
            <ListChecks size={28} />
          </span>
          <h1 className="mt-4 text-2xl font-bold tracking-tight">Quiz</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Up to {QUIZ_SIZE} questions, difficulty adapted to your recent
            accuracy.
          </p>
        </div>
        <div className="mt-8 grid gap-3 sm:grid-cols-2">
          <button
            onClick={() => void startQuiz("mixed")}
            className="rounded-card border border-primary/50 bg-primary/10 p-4 text-left font-semibold transition-all hover:-translate-y-0.5"
          >
            Mixed — all domains
            <span className="mt-1 block text-xs font-normal text-muted-foreground">
              {manifest.questions.length} questions in the bank
            </span>
          </button>
          {DOMAINS.map((domain) => {
            const n = counts.get(domain) ?? 0;
            if (n === 0) return null;
            return (
              <button
                key={domain}
                onClick={() => void startQuiz(domain)}
                className="rounded-card border border-border bg-card p-4 text-left transition-all hover:-translate-y-0.5 hover:border-border-strong"
              >
                <span className="flex items-center gap-2 font-semibold">
                  <span
                    className="size-2 rounded-full"
                    style={{ background: DOMAIN_HEX[domain] }}
                  />
                  {DOMAIN_LABELS[domain]}
                </span>
                <span className="mt-1 block text-xs text-muted-foreground">
                  {n} questions
                </span>
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  if (state.stage === "run") {
    const question = state.questions[state.index];
    return (
      <div className="mx-auto max-w-2xl px-4 py-8 md:px-8">
        <div className="flex items-center gap-3">
          <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-border">
            <div
              className="h-full rounded-full bg-gradient-to-r from-primary to-primary-light transition-all duration-300"
              style={{
                width: `${(state.index / state.questions.length) * 100}%`,
              }}
            />
          </div>
          <span className="text-xs font-medium text-faint">
            {state.index + 1}/{state.questions.length}
          </span>
        </div>

        <div className="mt-6 rounded-card border border-border bg-card p-6">
          <QuizQuestionCard
            key={question.id}
            question={question}
            domain={question.domain}
            onAnswered={(correct) =>
              setState((s) =>
                s.stage === "run"
                  ? { ...s, correct: s.correct + (correct ? 1 : 0), answered: true }
                  : s,
              )
            }
          />
        </div>

        {state.answered && (
          <div className="mt-5 text-center">
            <button
              onClick={() =>
                setState((s) => {
                  if (s.stage !== "run") return s;
                  const next = s.index + 1;
                  return next >= s.questions.length
                    ? {
                        stage: "done",
                        domain: s.domain,
                        total: s.questions.length,
                        correct: s.correct,
                      }
                    : { ...s, index: next, answered: false };
                })
              }
              className="rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
            >
              {state.index + 1 < state.questions.length
                ? "Next question"
                : "Finish quiz"}
            </button>
          </div>
        )}
      </div>
    );
  }

  const pct = Math.round((state.correct / state.total) * 100);
  return (
    <div className="mx-auto max-w-md px-4 py-16 text-center md:px-8">
      <span className="inline-block rounded-2xl bg-success/15 p-4 text-success">
        <Trophy size={28} />
      </span>
      <h1 className="mt-4 text-2xl font-bold">
        {state.correct}/{state.total} correct
      </h1>
      <p className="mt-1 text-sm text-muted-foreground">
        {pct >= 80 ? "Strong." : pct >= 60 ? "Solid — review the misses." : "Worth revisiting the fundamentals."}
      </p>
      <div className="mt-8 flex justify-center gap-3">
        <button
          onClick={() => setState({ stage: "pick" })}
          className="inline-flex items-center gap-2 rounded-lg bg-primary px-5 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
        >
          <RotateCcw size={15} /> Another quiz
        </button>
        <Link
          href="/progress"
          className="rounded-lg border border-border bg-card px-5 py-2.5 text-sm font-semibold transition-colors hover:border-border-strong"
        >
          View progress
        </Link>
      </div>
    </div>
  );
}

/** Sample questions weighted by adaptive difficulty tier ratios. */
async function sampleQuestions(
  all: QuizQuestionWithDomain[],
  domain: Domain | "mixed",
): Promise<QuizQuestionWithDomain[]> {
  const pool = domain === "mixed" ? all : all.filter((q) => q.domain === domain);

  const recent = await db.quizAttempts
    .orderBy("timestamp")
    .reverse()
    .limit(20)
    .toArray();
  const recentAccuracy =
    recent.length >= 5
      ? recent.filter((a) => a.correct).length / recent.length
      : 0.8;

  const { tierRatios } = computeSessionProfile({
    recentAccuracy,
    overdueCardCount: 0,
    confidenceCalibrationError: 0,
  });

  const byTier: Record<DifficultyTier, QuizQuestionWithDomain[]> = {
    1: [],
    2: [],
    3: [],
    4: [],
  };
  for (const q of pool) {
    const tier = Math.min(4, Math.max(1, q.difficulty)) as DifficultyTier;
    byTier[tier].push(q);
  }
  for (const tier of [1, 2, 3, 4] as const) {
    byTier[tier] = shuffle(byTier[tier]);
  }

  const target = Math.min(QUIZ_SIZE, pool.length);
  const picked: QuizQuestionWithDomain[] = [];
  for (const tier of [1, 2, 3, 4] as const) {
    picked.push(...byTier[tier].splice(0, Math.round(tierRatios[tier] * target)));
  }
  // Fill any shortfall from whatever tiers still have questions.
  const leftovers = shuffle([1, 2, 3, 4].flatMap((t) => byTier[t as DifficultyTier]));
  while (picked.length < target && leftovers.length > 0) {
    picked.push(leftovers.pop()!);
  }
  return shuffle(picked.slice(0, target));
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
