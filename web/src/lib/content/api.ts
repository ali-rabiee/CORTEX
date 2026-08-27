import {
  allConceptLevels,
  allConcepts,
  allQuizzes,
  chapter as chaptersFile,
  world as worldsFile,
} from "content-collections";

import { DOMAINS, type Domain, type Level } from "./schema";

export type Concept = (typeof allConcepts)[number];
export type ConceptLevel = (typeof allConceptLevels)[number];
export type QuizBank = (typeof allQuizzes)[number];

export function getConcept(id: string): Concept | undefined {
  return allConcepts.find((c) => c.id === id);
}

export function getConceptIds(): string[] {
  return allConcepts.map((c) => c.id);
}

/** Levels available for a concept, sorted 1..5 (gaps where not yet authored). */
export function getLevels(conceptId: string): ConceptLevel[] {
  return allConceptLevels
    .filter((l) => l.conceptId === conceptId)
    .sort((a, b) => a.level - b.level);
}

export function getLevel(
  conceptId: string,
  level: Level,
): ConceptLevel | undefined {
  return allConceptLevels.find(
    (l) => l.conceptId === conceptId && l.level === level,
  );
}

/** Concepts grouped by domain in canonical domain order, importance first. */
export function conceptsByDomain(): Array<{
  domain: Domain;
  concepts: Concept[];
}> {
  return DOMAINS.map((domain) => ({
    domain,
    concepts: allConcepts
      .filter((c) => c.domain === domain)
      .sort((a, b) => b.importance - a.importance || a.title.localeCompare(b.title)),
  })).filter((g) => g.concepts.length > 0);
}

export function getRelatedConcepts(concept: Concept): Concept[] {
  return concept.related_concept_ids
    .map((id) => getConcept(id))
    .filter((c): c is Concept => c !== undefined);
}

export const worlds = worldsFile.worlds;
export const chapters = chaptersFile.chapters;

export { allConceptLevels, allConcepts, allQuizzes };
