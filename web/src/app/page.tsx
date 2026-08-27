import { ArrowRight, BookOpen, Layers, Zap } from "lucide-react";
import Link from "next/link";

import { HomeDashboard } from "@/components/home-dashboard";
import { allConcepts, conceptsByDomain } from "@/lib/content/api";
import { buildSessionManifest } from "@/lib/content/manifest-server";
import { DOMAIN_LABELS } from "@/lib/content/schema";
import { DOMAIN_HEX } from "@/lib/domains";

export default function HomePage() {
  const groups = conceptsByDomain();
  const manifest = buildSessionManifest();

  return (
    <div className="mx-auto max-w-5xl px-4 py-10 md:px-8">
      <HomeDashboard manifest={manifest} />
      <section className="rounded-card border border-border bg-gradient-to-br from-surface to-card p-8 md:p-10">
        <p className="text-xs font-semibold uppercase tracking-widest text-primary-light">
          Daily cognitive training
        </p>
        <h1 className="mt-2 max-w-xl text-3xl font-bold leading-tight tracking-tight md:text-4xl">
          Master modern robotics &amp; ML, one level at a time.
        </h1>
        <p className="mt-3 max-w-xl text-sm leading-relaxed text-muted-foreground md:text-base">
          {allConcepts.length} concepts. Five mastery levels each — intuition,
          math, code, frontier papers, application. Spaced repetition keeps
          what you learn from fading.
        </p>
        <div className="mt-6 flex flex-wrap gap-3">
          <Link
            href="/learn"
            className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2.5 text-sm font-semibold text-primary-foreground transition-colors hover:bg-primary-dark"
          >
            <BookOpen size={16} /> Start learning <ArrowRight size={15} />
          </Link>
          <Link
            href="/session"
            className="inline-flex items-center gap-2 rounded-lg border border-border bg-card px-4 py-2.5 text-sm font-semibold transition-colors hover:border-border-strong"
          >
            <Zap size={16} className="text-warning" /> Daily session
          </Link>
        </div>
      </section>

      <section className="mt-8">
        <div className="mb-4 flex items-center gap-2 text-sm font-semibold text-muted-foreground">
          <Layers size={15} /> Domains
        </div>
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {groups.map(({ domain, concepts }) => (
            <Link
              key={domain}
              href={`/learn#${domain}`}
              className="group rounded-card border border-border bg-card p-4 transition-all hover:-translate-y-0.5 hover:border-border-strong"
            >
              <div className="flex items-center gap-2.5">
                <span
                  className="size-2.5 rounded-full"
                  style={{ background: DOMAIN_HEX[domain] }}
                  aria-hidden
                />
                <span className="font-semibold group-hover:text-primary-light">
                  {DOMAIN_LABELS[domain]}
                </span>
              </div>
              <p className="mt-1.5 text-xs text-faint">
                {concepts.length} concepts
              </p>
            </Link>
          ))}
        </div>
      </section>
    </div>
  );
}
