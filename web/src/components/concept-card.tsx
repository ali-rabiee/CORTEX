import Link from "next/link";

import { ConceptRing } from "@/components/concept-ring";
import { MathText } from "@/components/math-text";
import type { Concept } from "@/lib/content/api";
import { DOMAIN_HEX } from "@/lib/domains";

export function ConceptCard({
  concept,
  availableLevels,
}: {
  concept: Concept;
  availableLevels: number[];
}) {
  const color = DOMAIN_HEX[concept.domain];
  return (
    <Link
      href={`/concepts/${concept.id}`}
      className="group flex items-start gap-4 rounded-card border border-border bg-card p-4 transition-all hover:-translate-y-0.5 hover:border-border-strong hover:bg-surface"
    >
      <div className="shrink-0 pt-0.5">
        <ConceptRing
          conceptId={concept.id}
          color={color}
          availableLevels={availableLevels}
          size={44}
        />
      </div>
      <div className="min-w-0">
        <div className="flex items-center gap-2">
          <h3 className="truncate font-semibold leading-snug group-hover:text-primary-light">
            {concept.title}
          </h3>
        </div>
        <p className="mt-1 line-clamp-2 text-sm leading-relaxed text-muted-foreground">
          <MathText text={concept.summary} />
        </p>
        <div className="mt-2 flex items-center gap-3 text-[0.7rem] text-faint">
          <span>
            {"●".repeat(concept.difficulty)}
            {"○".repeat(4 - concept.difficulty)} difficulty
          </span>
          <span>importance {concept.importance}/5</span>
        </div>
      </div>
    </Link>
  );
}
