"use client";

import { CheckCircle2, ChevronRight, XCircle } from "lucide-react";
import { useState } from "react";

import { LevelUpDialog } from "@/components/level-up-dialog";
import { MathText } from "@/components/math-text";
import { useConceptProgress } from "@/lib/db/hooks";
import { passLevel, recordCheckAttempt } from "@/lib/db/repos";
import { isLevelPassed } from "@/lib/engine/levels";
import type { CheckQuestion, Level } from "@/lib/content/schema";

/**
 * Level-up gate rendered at the bottom of each level panel. Seed levels
 * without authored checks fall back to a self-attested "mark as understood".
 */
export function LevelCheck({
  conceptId,
  conceptTitle,
  level,
  checks,
  color,
}: {
  conceptId: string;
  conceptTitle: string;
  level: Level;
  checks: CheckQuestion[];
  color: string;
}) {
  const progress = useConceptProgress(conceptId);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [submitted, setSubmitted] = useState(false);
  const [dialog, setDialog] = useState<{ xp: number } | null>(null);

  if (progress === undefined) return null; // db loading
  const passed = (progress?.currentLevel ?? 0) >= level;
  const passedAt = progress?.levelPassedAt?.[level];

  if (passed) {
    // The level-up dialog must stay mounted here: passLevel() flips this
    // component into the passed branch on the very next live-query tick.
    return (
      <>
        <div className="mt-8 flex items-center gap-2.5 rounded-card border border-success/30 bg-success/10 p-4 text-sm font-medium text-success">
          <CheckCircle2 size={17} />
          Level {level} passed
          {passedAt ? ` · ${new Date(passedAt).toLocaleDateString()}` : ""}
        </div>
        <LevelUpDialog
          open={dialog !== null}
          onClose={() => setDialog(null)}
          conceptTitle={conceptTitle}
          level={level}
          xpGained={dialog?.xp ?? 0}
          color={color}
        />
      </>
    );
  }

  const handlePass = async () => {
    const { xpGained } = await passLevel({ conceptId, level });
    setDialog({ xp: xpGained });
  };

  // Seed content: no authored check questions yet → self-attest.
  if (checks.length === 0) {
    return (
      <>
        <div className="mt-8 rounded-card border border-border bg-surface/60 p-5">
          <h3 className="text-sm font-semibold">Ready to move on?</h3>
          <p className="mt-1 text-sm text-muted-foreground">
            This level doesn&apos;t have a check yet. Mark it understood once
            you can explain it without looking.
          </p>
          <button
            onClick={handlePass}
            className="mt-4 inline-flex items-center gap-1.5 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
          >
            Mark level {level} understood <ChevronRight size={15} />
          </button>
        </div>
        <LevelUpDialog
          open={dialog !== null}
          onClose={() => setDialog(null)}
          conceptTitle={conceptTitle}
          level={level}
          xpGained={dialog?.xp ?? 0}
          color={color}
        />
      </>
    );
  }

  const allAnswered = checks.every((q) => answers[q.id] !== undefined);
  const correctCount = checks.filter((q) => answers[q.id] === q.answer).length;
  const passedCheck = isLevelPassed(correctCount, checks.length);

  const handleSubmit = async () => {
    setSubmitted(true);
    await recordCheckAttempt(conceptId);
    if (passedCheck) {
      await handlePass();
    }
  };

  return (
    <>
      <div className="mt-8 rounded-card border border-border bg-surface/60 p-5">
        <h3 className="flex items-center gap-2 text-sm font-semibold">
          <span
            className="rounded-md px-1.5 py-0.5 text-[0.7rem] font-bold uppercase tracking-wide"
            style={{ color, background: `color-mix(in srgb, ${color} 14%, transparent)` }}
          >
            Level {level} check
          </span>
          {checks.length} question{checks.length > 1 ? "s" : ""} · pass at 80%
        </h3>

        <div className="mt-4 space-y-5">
          {checks.map((q, qi) => {
            const selected = answers[q.id];
            return (
              <div key={q.id}>
                <p className="text-sm font-medium leading-relaxed">
                  {qi + 1}. <MathText text={q.prompt} />
                </p>
                <div className="mt-2 space-y-1.5">
                  {q.options.map((opt, oi) => {
                    const isSelected = selected === oi;
                    const isCorrect = oi === q.answer;
                    let style = "border-border bg-card hover:border-border-strong";
                    if (submitted && isCorrect) {
                      style = "border-success/60 bg-success/10";
                    } else if (submitted && isSelected && !isCorrect) {
                      style = "border-danger/60 bg-danger/10";
                    } else if (isSelected) {
                      style = "border-primary/60 bg-primary/10";
                    }
                    return (
                      <button
                        key={oi}
                        disabled={submitted}
                        onClick={() =>
                          setAnswers((a) => ({ ...a, [q.id]: oi }))
                        }
                        className={`flex w-full items-start gap-2.5 rounded-lg border px-3 py-2.5 text-left text-sm transition-colors disabled:cursor-default ${style}`}
                      >
                        <span className="mt-0.5 shrink-0 text-xs font-bold text-faint">
                          {String.fromCharCode(65 + oi)}
                        </span>
                        <span className="leading-relaxed">
                          <MathText text={opt} />
                        </span>
                        {submitted && isCorrect && (
                          <CheckCircle2 size={15} className="ml-auto mt-0.5 shrink-0 text-success" />
                        )}
                        {submitted && isSelected && !isCorrect && (
                          <XCircle size={15} className="ml-auto mt-0.5 shrink-0 text-danger" />
                        )}
                      </button>
                    );
                  })}
                </div>
                {submitted && (
                  <p className="mt-2 rounded-lg bg-card p-3 text-xs leading-relaxed text-muted-foreground">
                    <MathText text={q.explanation} />
                  </p>
                )}
              </div>
            );
          })}
        </div>

        {!submitted ? (
          <button
            onClick={handleSubmit}
            disabled={!allAnswered}
            className="mt-5 rounded-lg bg-primary px-4 py-2 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark disabled:cursor-not-allowed disabled:opacity-40"
          >
            Submit answers
          </button>
        ) : !passedCheck ? (
          <div className="mt-5 flex flex-wrap items-center gap-3">
            <p className="text-sm text-danger">
              {correctCount}/{checks.length} correct — review the material and
              try again.
            </p>
            <button
              onClick={() => {
                setAnswers({});
                setSubmitted(false);
              }}
              className="rounded-lg border border-border bg-card px-3 py-1.5 text-sm font-medium transition-colors hover:border-border-strong"
            >
              Retry
            </button>
          </div>
        ) : null}
      </div>

      <LevelUpDialog
        open={dialog !== null}
        onClose={() => setDialog(null)}
        conceptTitle={conceptTitle}
        level={level}
        xpGained={dialog?.xp ?? 0}
        color={color}
      />
    </>
  );
}
