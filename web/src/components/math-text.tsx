"use client";

import katex from "katex";
import { useMemo } from "react";

import { KATEX_MACROS, splitMathSegments } from "@/lib/content/math";

/**
 * Renders a plain string that may contain inline `$...$` or display `$$...$$`
 * LaTeX segments. Used for quiz questions, check options, and recall prompts —
 * content that is NOT compiled MDX.
 */
export function MathText({
  text,
  className,
}: {
  text: string;
  className?: string;
}) {
  const html = useMemo(() => renderMathInString(text), [text]);
  return (
    <span className={className} dangerouslySetInnerHTML={{ __html: html }} />
  );
}

function escapeHtml(s: string): string {
  return s
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;");
}

function renderMathInString(text: string): string {
  return splitMathSegments(text)
    .map((seg) => {
      if (seg.type === "text") return escapeHtml(seg.value);
      const display = seg.value.startsWith("$$");
      const latex = display ? seg.value.slice(2, -2) : seg.value.slice(1, -1);
      try {
        return katex.renderToString(latex, {
          displayMode: display,
          throwOnError: true,
          macros: { ...KATEX_MACROS },
        });
      } catch {
        return `<code>${escapeHtml(seg.value)}</code>`;
      }
    })
    .join("");
}
