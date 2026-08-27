import type { Domain, QuizQuestion, Recall } from "./schema";

/**
 * Compact content manifest passed from server pages into client components
 * (session player, dashboard). Deliberately excludes compiled MDX bodies so
 * client bundles stay small.
 */

export type ConceptInfo = {
  id: string;
  title: string;
  domain: Domain;
  difficulty: number;
  /** Levels with authored content. */
  availableLevels: number[];
};

export type SessionManifest = {
  concepts: Record<string, ConceptInfo>;
  /** Recall prompts keyed by `${conceptId}:${level}`. */
  recalls: Record<string, Recall>;
  questions: Array<QuizQuestion & { domain: Domain }>;
};

export function recallKey(conceptId: string, level: number): string {
  return `${conceptId}:${level}`;
}

/** Best recall prompt for a concept at the user's current level: exact level,
 * else the highest authored level below it, else any. */
export function recallFor(
  manifest: SessionManifest,
  conceptId: string,
  level: number,
): Recall | undefined {
  for (let l = level; l >= 1; l--) {
    const r = manifest.recalls[recallKey(conceptId, l)];
    if (r) return r;
  }
  for (let l = level + 1; l <= 5; l++) {
    const r = manifest.recalls[recallKey(conceptId, l)];
    if (r) return r;
  }
  return undefined;
}
