import {
  AlertTriangle,
  Lightbulb,
  Sparkles,
  type LucideIcon,
} from "lucide-react";
import type { ReactNode } from "react";

function Callout({
  icon: Icon,
  label,
  accent,
  children,
}: {
  icon: LucideIcon;
  label: string;
  accent: string;
  children: ReactNode;
}) {
  return (
    <aside
      className="my-5 rounded-card border bg-surface/60 p-4"
      style={{ borderColor: `color-mix(in srgb, ${accent} 35%, transparent)` }}
    >
      <div
        className="mb-2 flex items-center gap-2 text-sm font-semibold"
        style={{ color: accent }}
      >
        <Icon size={16} strokeWidth={2.2} />
        {label}
      </div>
      <div className="text-[0.95rem] leading-relaxed text-foreground [&>*+*]:mt-3">
        {children}
      </div>
    </aside>
  );
}

/** Plain-language framing of an idea — "how to think about this". */
export function Intuition({ children }: { children: ReactNode }) {
  return (
    <Callout icon={Lightbulb} label="Intuition" accent="var(--color-warning)">
      {children}
    </Callout>
  );
}

/** The one thing to remember from a section. */
export function KeyIdea({ children }: { children: ReactNode }) {
  return (
    <Callout icon={Sparkles} label="Key idea" accent="var(--color-primary-light)">
      {children}
    </Callout>
  );
}

/** Common pitfalls, failure modes, sharp edges. */
export function Warning({ children }: { children: ReactNode }) {
  return (
    <Callout icon={AlertTriangle} label="Watch out" accent="var(--color-danger)">
      {children}
    </Callout>
  );
}
