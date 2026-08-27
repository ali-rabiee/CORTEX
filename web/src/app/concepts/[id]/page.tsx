import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { ConceptRing } from "@/components/concept-ring";
import { DomainChip } from "@/components/domain-chip";
import { LevelCheck } from "@/components/level-check";
import { LevelTabs, type LevelTabItem } from "@/components/level-tabs";
import { MathText } from "@/components/math-text";
import { MdxBody } from "@/components/mdx/mdx-body";
import {
  getConcept,
  getConceptIds,
  getLevels,
  getRelatedConcepts,
} from "@/lib/content/api";
import type { Level } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";

export function generateStaticParams() {
  return getConceptIds().map((id) => ({ id }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const concept = getConcept(id);
  return { title: concept?.title ?? "Concept" };
}

export default async function ConceptPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const concept = getConcept(id);
  if (!concept) notFound();

  const levels = getLevels(id);
  const related = getRelatedConcepts(concept);
  const color = DOMAIN_HEX[concept.domain];

  const items: LevelTabItem[] = levels.map((l) => ({
    level: l.level as Level,
    status: l.status,
  }));

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 md:px-8">
      <header className="mb-8">
        <div className="flex items-start justify-between gap-4">
          <div>
            <DomainChip domain={concept.domain} />
            <h1 className="mt-3 text-2xl font-bold leading-tight tracking-tight md:text-3xl">
              {concept.title}
            </h1>
            <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
              <MathText text={concept.summary} />
            </p>
          </div>
          <div className="shrink-0 pt-1">
            <ConceptRing
              conceptId={concept.id}
              color={color}
              availableLevels={items.map((i) => i.level)}
              size={56}
              strokeWidth={5}
            />
          </div>
        </div>
        <div className="mt-3 flex items-center gap-4 text-xs text-faint">
          <span>
            difficulty {"●".repeat(concept.difficulty)}
            {"○".repeat(4 - concept.difficulty)}
          </span>
          <span>importance {concept.importance}/5</span>
        </div>
      </header>

      <LevelTabs
        conceptId={concept.id}
        items={items}
        color={color}
        panels={levels.map((l) => (
          <div key={l.level}>
            <MdxBody code={l.body} papers={l.papers} />
            <LevelCheck
              conceptId={concept.id}
              conceptTitle={concept.title}
              level={l.level as Level}
              checks={l.check}
              color={color}
            />
          </div>
        ))}
      />

      {related.length > 0 && (
        <footer className="mt-12 border-t border-border pt-6">
          <h2 className="mb-3 text-sm font-semibold text-muted-foreground">
            Related concepts
          </h2>
          <div className="flex flex-wrap gap-2">
            {related.map((r) => (
              <Link
                key={r.id}
                href={`/concepts/${r.id}`}
                className="rounded-full border border-border bg-card px-3 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:border-border-strong hover:text-foreground"
              >
                {r.title}
              </Link>
            ))}
          </div>
        </footer>
      )}
    </div>
  );
}
