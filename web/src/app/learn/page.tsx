import type { Metadata } from "next";

import { ConceptCard } from "@/components/concept-card";
import { CurriculumPath } from "@/components/curriculum-path";
import { LearnTabs } from "@/components/learn-tabs";
import {
  chapters,
  conceptsByDomain,
  getLevels,
  worlds,
} from "@/lib/content/api";
import { buildSessionManifest } from "@/lib/content/manifest-server";
import { DOMAIN_LABELS } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";

export const metadata: Metadata = { title: "Learn" };

export default function LearnPage() {
  const groups = conceptsByDomain();
  const totalConcepts = groups.reduce((n, g) => n + g.concepts.length, 0);
  const manifest = buildSessionManifest();

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 md:px-8">
      <header className="mb-6">
        <h1 className="text-2xl font-bold tracking-tight">Learn</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {totalConcepts} concepts · {worlds.length} worlds. Each concept has 5
          mastery levels: intuition → math → code → frontier → application.
        </p>
      </header>

      <LearnTabs
        path={
          <CurriculumPath
            worlds={worlds}
            chapters={chapters}
            concepts={manifest.concepts}
          />
        }
        browse={
          <div className="space-y-10">
            {groups.map(({ domain, concepts }) => (
              <section key={domain} id={domain}>
                <div className="mb-4 flex items-center gap-3">
                  <span
                    className="size-2.5 rounded-full"
                    style={{ background: DOMAIN_HEX[domain] }}
                    aria-hidden
                  />
                  <h2 className="text-lg font-semibold tracking-tight">
                    {DOMAIN_LABELS[domain]}
                  </h2>
                  <span className="text-xs text-faint">
                    {concepts.length} concepts
                  </span>
                </div>
                <div className="grid gap-3 sm:grid-cols-2">
                  {concepts.map((concept) => (
                    <ConceptCard
                      key={concept.id}
                      concept={concept}
                      availableLevels={getLevels(concept.id).map((l) => l.level)}
                    />
                  ))}
                </div>
              </section>
            ))}
          </div>
        }
      />
    </div>
  );
}
