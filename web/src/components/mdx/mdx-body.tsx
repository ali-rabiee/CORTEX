import { MDXContent } from "@content-collections/mdx/react";

import type {
  InterviewMaterial,
  MediaRef,
  PaperRef,
} from "@/lib/content/schema";

import { Intuition, KeyIdea, Warning } from "./callouts";
import { CodeWalk } from "./code-walk";
import { Derivation } from "./derivation";
import { Figure } from "./figure";
import { InterviewAnswer } from "./interview-answer";
import { PaperCard, PaperGrid } from "./paper-card";
import { Step, Steps } from "./steps";
import { WatchThis } from "./watch-this";

/**
 * Renders a compiled concept-level MDX body with the CORTEX component set.
 *
 * Structured frontmatter (`papers`, `media`, `interview`) is bound into the
 * components that consume it, so MDX can just write `<WatchThis />` or
 * `<InterviewAnswer />` and place them wherever they read best.
 */
export function MdxBody({
  code,
  papers = [],
  media = [],
  interview,
}: {
  code: string;
  papers?: PaperRef[];
  media?: MediaRef[];
  interview?: InterviewMaterial;
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
          Steps,
          Step,
          Figure,
          PaperGrid,
          PaperCard: (props: { refKey?: string; paper?: PaperRef }) => (
            <PaperCard {...props} papers={papers} />
          ),
          WatchThis: (props: { title?: string }) => (
            <WatchThis {...props} media={media} />
          ),
          InterviewAnswer: () => <InterviewAnswer interview={interview} />,
        }}
      />
    </div>
  );
}
