import { ChevronRight, MessageSquareQuote, ThumbsDown, Timer } from "lucide-react";

import { MathText } from "@/components/math-text";
import type { InterviewMaterial } from "@/lib/content/schema";

/** Rough speaking pace, for the "how long will this take to say" hint. */
const WORDS_PER_MINUTE = 140;

function speakingTime(text: string): string {
  const words = text.trim().split(/\s+/).length;
  const seconds = Math.round((words / WORDS_PER_MINUTE) * 60);
  return seconds < 60 ? `~${seconds}s` : `~${Math.round(seconds / 15) / 4} min`;
}

/**
 * The payload of a level 5 file: what you actually say when someone asks you
 * about this concept, what they ask next, and the answers that lose the room.
 *
 * Driven by the level's `interview` frontmatter, so it stays structured data
 * rather than prose the review engine can't reach.
 */
export function InterviewAnswer({
  interview,
}: {
  interview?: InterviewMaterial;
}) {
  if (!interview) return null;

  return (
    <section className="my-6">
      <div className="rounded-card border border-primary/30 bg-primary/[0.06] p-5">
        <div className="flex items-center justify-between gap-3">
          <h3 className="flex items-center gap-2 text-sm font-semibold text-primary-light">
            <MessageSquareQuote size={16} strokeWidth={2.2} />
            Say this
          </h3>
          <span className="flex items-center gap-1.5 text-xs text-faint">
            <Timer size={13} />
            {speakingTime(interview.answer)}
          </span>
        </div>
        <p className="mt-3 text-[0.97rem] leading-[1.75] text-foreground">
          <MathText text={interview.answer} />
        </p>
      </div>

      {interview.followUps.length > 0 && (
        <div className="mt-4">
          <h3 className="mb-2 text-sm font-semibold text-muted-foreground">
            What they ask next
          </h3>
          <div className="grid gap-2">
            {interview.followUps.map((f) => (
              <details
                key={f.q}
                className="group rounded-card border border-border bg-card"
              >
                <summary className="flex cursor-pointer select-none items-start gap-2 p-3.5 text-sm font-medium transition-colors hover:text-foreground [&::-webkit-details-marker]:hidden">
                  <ChevronRight
                    size={15}
                    className="mt-0.5 shrink-0 text-faint transition-transform group-open:rotate-90"
                  />
                  <span>
                    <MathText text={f.q} />
                  </span>
                </summary>
                <p className="border-t border-border px-3.5 py-3 pl-[2.4rem] text-sm leading-relaxed text-muted-foreground">
                  <MathText text={f.a} />
                </p>
              </details>
            ))}
          </div>
        </div>
      )}

      {interview.traps.length > 0 && (
        <div className="mt-4 rounded-card border border-danger/30 bg-danger/5 p-4">
          <h3 className="flex items-center gap-2 text-sm font-semibold text-danger">
            <ThumbsDown size={15} strokeWidth={2.2} /> Don&apos;t say
          </h3>
          <ul className="mt-2.5 grid gap-2">
            {interview.traps.map((trap) => (
              <li
                key={trap}
                className="flex gap-2 text-sm leading-relaxed text-muted-foreground"
              >
                <span aria-hidden className="mt-[0.15rem] text-danger">
                  ✗
                </span>
                <span>
                  <MathText text={trap} />
                </span>
              </li>
            ))}
          </ul>
        </div>
      )}
    </section>
  );
}
