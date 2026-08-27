/**
 * Matches `$$...$$` display math or `$...$` inline math. Inside inline math,
 * backslash-escaped characters (notably `\$`) are allowed without terminating
 * the span.
 */
export const MATH_SEGMENT = /\$\$[\s\S]+?\$\$|\$(?:\\[\s\S]|[^$\n\\])+?\$/g;

/**
 * Shared KaTeX macros. `\textdollar` exists because a literal `\$` cannot
 * appear inside micromark math spans (the `$` would terminate the span); the
 * migration script rewrites `\$` → `\textdollar` and this macro renders it.
 */
export const KATEX_MACROS: Record<string, string> = {
  "\\textdollar": "\\text{\\$}",
};

export type TextSegment = { type: "text" | "math"; value: string };

/** Split a string into alternating prose and math segments. */
export function splitMathSegments(text: string): TextSegment[] {
  const segments: TextSegment[] = [];
  let last = 0;
  for (const m of text.matchAll(MATH_SEGMENT)) {
    if (m.index > last) {
      segments.push({ type: "text", value: text.slice(last, m.index) });
    }
    segments.push({ type: "math", value: m[0] });
    last = m.index + m[0].length;
  }
  if (last < text.length) {
    segments.push({ type: "text", value: text.slice(last) });
  }
  return segments;
}
