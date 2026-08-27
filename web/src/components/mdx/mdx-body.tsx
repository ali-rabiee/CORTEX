import { MDXContent } from "@content-collections/mdx/react";

import type { PaperRef } from "@/lib/content/schema";

import { Intuition, KeyIdea, Warning } from "./callouts";
import { CodeWalk } from "./code-walk";
import { Derivation } from "./derivation";
import { PaperCard, PaperGrid } from "./paper-card";

/**
 * Renders a compiled concept-level MDX body with the CORTEX component set.
 * `papers` (the level's frontmatter citations) is bound into PaperCard so MDX
 * can write `<PaperCard refKey="chi2023diffusion" />`.
 */
export function MdxBody({
  code,
  papers = [],
}: {
  code: string;
  papers?: PaperRef[];
}) {
  return (
    <div className="mdx-content">
      <MDXContent
        code={code}
        components={{
          Intuition,
          KeyIdea,
          Warning,
          Derivation,
          CodeWalk,
          PaperGrid,
          PaperCard: (props: { refKey?: string; paper?: PaperRef }) => (
            <PaperCard {...props} papers={papers} />
          ),
        }}
      />
    </div>
  );
}
