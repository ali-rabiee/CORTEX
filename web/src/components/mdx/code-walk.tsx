import { Terminal } from "lucide-react";
import type { ReactNode } from "react";

/**
 * Frames a code block with a short narrative — "what this code shows".
 * Usage in MDX:
 *
 * <CodeWalk title="PPO clipped loss in PyTorch">
 *   Lead-in prose...
 *   ```python ...```
 * </CodeWalk>
 */
export function CodeWalk({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}) {
  return (
    <section className="my-6 rounded-card border border-domain-robot/30 bg-surface/40">
      <div className="flex items-center gap-2 border-b border-border px-4 py-3 text-sm font-semibold text-domain-robot">
        <Terminal size={15} />
        {title}
      </div>
      <div className="p-4 [&>*+*]:mt-3 [&_figure[data-rehype-pretty-code-figure]]:my-3">
        {children}
      </div>
    </section>
  );
}
