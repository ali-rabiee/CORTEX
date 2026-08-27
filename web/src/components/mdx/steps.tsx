import type { ReactNode } from "react";

/**
 * A numbered walkthrough. Use it wherever a concept is really a *sequence* —
 * how the algorithm runs, how a derivation proceeds, how you'd debug something.
 *
 * ```mdx
 * <Steps>
 * <Step title="Collect demonstrations">…</Step>
 * <Step title="Fit the policy">…</Step>
 * </Steps>
 * ```
 *
 * Numbering comes from a CSS counter, so steps can be reordered freely.
 */
export function Steps({ children }: { children: ReactNode }) {
  return <ol className="cortex-steps my-6">{children}</ol>;
}

export function Step({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}) {
  return (
    <li className="cortex-step">
      <h4 className="cortex-step-title">{title}</h4>
      <div className="cortex-step-body">{children}</div>
    </li>
  );
}
