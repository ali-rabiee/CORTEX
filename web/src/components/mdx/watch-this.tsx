import { BookOpen, ExternalLink, MousePointerClick, Presentation, Play } from "lucide-react";
import type { LucideIcon } from "lucide-react";

import type { MediaRef } from "@/lib/content/schema";

const KIND_META: Record<MediaRef["kind"], { icon: LucideIcon; label: string }> = {
  video: { icon: Play, label: "Video" },
  lecture: { icon: Presentation, label: "Lecture" },
  article: { icon: BookOpen, label: "Read" },
  interactive: { icon: MousePointerClick, label: "Interactive" },
};

/**
 * The handful of external explanations actually worth your time for this
 * concept, from the level's `media` frontmatter.
 *
 * These are links, not embeds: an embedded player would break offline use and
 * drag third-party scripts into a page that otherwise has none.
 */
export function WatchThis({
  media = [],
  title = "Watch / read this first",
}: {
  media?: MediaRef[];
  title?: string;
}) {
  if (media.length === 0) return null;

  return (
    <section className="my-6">
      <h3 className="mb-2.5 text-sm font-semibold text-muted-foreground">
        {title}
      </h3>
      <ul className="grid gap-2.5">
        {media.map((item) => {
          const { icon: Icon, label } = KIND_META[item.kind];
          return (
            <li key={item.url}>
              <a
                href={item.url}
                target="_blank"
                rel="noopener noreferrer"
                className="group flex gap-3 rounded-card border border-border bg-card p-3.5 transition-colors hover:border-border-strong"
              >
                <span className="mt-0.5 shrink-0 rounded-lg bg-primary/15 p-2 text-primary-light">
                  <Icon size={16} strokeWidth={2.2} />
                </span>
                <span className="min-w-0 flex-1">
                  <span className="flex items-start justify-between gap-2">
                    <span className="text-sm font-semibold leading-snug text-foreground">
                      {item.title}
                    </span>
                    <ExternalLink
                      size={13}
                      className="mt-1 shrink-0 text-faint transition-colors group-hover:text-muted-foreground"
                    />
                  </span>
                  <span className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-0.5 text-xs text-faint">
                    <span>{label}</span>
                    <span aria-hidden>·</span>
                    <span>{item.source}</span>
                    {item.minutes !== undefined && (
                      <>
                        <span aria-hidden>·</span>
                        <span>{item.minutes} min</span>
                      </>
                    )}
                  </span>
                  {item.note && (
                    <span className="mt-1.5 block text-xs leading-relaxed text-muted-foreground">
                      {item.note}
                    </span>
                  )}
                </span>
              </a>
            </li>
          );
        })}
      </ul>
    </section>
  );
}
