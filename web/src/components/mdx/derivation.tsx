import { ChevronRight, SquareSigma } from "lucide-react";
import type { ReactNode } from "react";

/**
 * Collapsible derivation block. Rendered with <details> so it works in
 * statically exported pages without client JS.
 */
export function Derivation({
  title = "Derivation",
  children,
}: {
  title?: string;
  children: ReactNode;
}) {
  return (
    <details className="group my-5 rounded-card border border-border bg-surface/60">
      <summary className="flex cursor-pointer select-none items-center gap-2 p-4 text-sm font-semibold text-muted-foreground transition-colors hover:text-foreground [&::-webkit-details-marker]:hidden">
        <ChevronRight
          size={16}
          className="transition-transform group-open:rotate-90"
        />
        <SquareSigma size={16} className="text-primary-light" />
        {title}
      </summary>
      <div className="border-t border-border p-4 pt-3 text-[0.95rem] leading-relaxed [&>*+*]:mt-3">
        {children}
      </div>
    </details>
  );
}
