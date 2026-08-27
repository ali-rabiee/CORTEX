"use client";

import { CheckCircle2, XCircle } from "lucide-react";
import { useState } from "react";

import { MathText } from "@/components/math-text";
import { db } from "@/lib/db/db";
import type { Domain, QuizQuestion } from "@/lib/content/schema";

/** One MCQ with instant feedback. Records the attempt in IndexedDB. */
export function QuizQuestionCard({
  question,
  domain,
  onAnswered,
}: {
  question: QuizQuestion;
  domain: Domain;
  onAnswered: (correct: boolean) => void;
}) {
  const [selected, setSelected] = useState<number | null>(null);
  const answered = selected !== null;

  const select = async (i: number) => {
    if (answered) return;
    setSelected(i);
    const correct = i === question.correct_answer;
    await db.quizAttempts.add({
      questionId: question.id,
      domain,
      selected: i,
      correct,
      conceptIds: question.concept_ids,
      timestamp: new Date().toISOString(),
    });
    onAnswered(correct);
  };

  return (
    <div>
      <p className="text-base font-medium leading-relaxed">
        <MathText text={question.question} />
      </p>
      <div className="mt-4 space-y-2">
        {question.options.map((opt, i) => {
          const isCorrect = i === question.correct_answer;
          const isSelected = selected === i;
          let style = "border-border bg-card hover:border-border-strong";
          if (answered && isCorrect) style = "border-success/60 bg-success/10";
          else if (answered && isSelected) style = "border-danger/60 bg-danger/10";
          return (
            <button
              key={i}
              disabled={answered}
              onClick={() => void select(i)}
              className={`flex w-full items-start gap-3 rounded-lg border px-4 py-3 text-left text-sm transition-colors disabled:cursor-default ${style}`}
            >
              <span className="mt-0.5 shrink-0 text-xs font-bold text-faint">
                {String.fromCharCode(65 + i)}
              </span>
              <span className="leading-relaxed">
                <MathText text={opt} />
              </span>
              {answered && isCorrect && (
                <CheckCircle2 size={16} className="ml-auto mt-0.5 shrink-0 text-success" />
              )}
              {answered && isSelected && !isCorrect && (
                <XCircle size={16} className="ml-auto mt-0.5 shrink-0 text-danger" />
              )}
            </button>
          );
        })}
      </div>
      {answered && (
        <p className="mt-4 rounded-lg border border-border bg-surface p-4 text-sm leading-relaxed text-muted-foreground">
          <MathText text={question.explanation} />
        </p>
      )}
    </div>
  );
}
