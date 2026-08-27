import { ExternalLink, FileText } from "lucide-react";

import type { PaperRef } from "@/lib/content/schema";

function paperUrl(paper: PaperRef): string | undefined {
  if (paper.url) return paper.url;
  if (paper.arxiv) return `https://arxiv.org/abs/${paper.arxiv}`;
  return undefined;
}

/**
 * Citation card for a single paper. In MDX, reference a frontmatter paper by
 * key: `<PaperCard refKey="chi2023diffusion" />` — the page binds the level's
 * `papers` list when registering MDX components.
 */
export function PaperCard({
  paper,
  refKey,
  papers,
}: {
  paper?: PaperRef;
  refKey?: string;
  papers?: PaperRef[];
}) {
  const resolved =
    paper ?? (refKey ? papers?.find((p) => p.key === refKey) : undefined);

  if (!resolved) {
    return (
      <div className="my-4 rounded-card border border-danger/40 bg-danger/10 p-4 text-sm text-danger">
        Unknown paper reference{refKey ? `: ${refKey}` : ""} — check the
        level&apos;s <code>papers</code> frontmatter.
      </div>
    );
  }

  const url = paperUrl(resolved);
  const meta = [resolved.authors, resolved.venue, String(resolved.year)]
    .filter(Boolean)
    .join(" · ");

  return (
    <div className="my-4 rounded-card border border-border bg-surface/60 p-4 transition-colors hover:border-border-strong">
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-start gap-3">
          <div className="mt-0.5 rounded-lg bg-primary/15 p-2 text-primary-light">
            <FileText size={16} />
          </div>
          <div>
            <div className="font-semibold leading-snug">
              {url ? (
                <a
                  href={url}
                  target="_blank"
                  rel="noreferrer"
                  className="!text-foreground !no-underline hover:!text-primary-light"
                >
                  {resolved.title}
                </a>
              ) : (
                resolved.title
              )}
            </div>
            <div className="mt-0.5 text-xs text-muted-foreground">{meta}</div>
          </div>
        </div>
        {url && (
          <a
            href={url}
            target="_blank"
            rel="noreferrer"
            aria-label={`Open ${resolved.title}`}
            className="shrink-0 rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-card hover:text-foreground"
          >
            <ExternalLink size={14} />
          </a>
        )}
      </div>
      <p className="mt-3 border-l-2 border-primary/50 pl-3 text-sm leading-relaxed text-muted-foreground">
        {resolved.takeaway}
      </p>
    </div>
  );
}

/** Grid wrapper used on L4 (frontier) levels to lay out PaperCards. */
export function PaperGrid({ children }: { children: React.ReactNode }) {
  return <div className="my-5 grid gap-3 sm:grid-cols-1">{children}</div>;
}
