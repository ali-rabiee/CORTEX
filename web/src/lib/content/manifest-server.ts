import { allConceptLevels, allConcepts, allQuizzes } from "./api";
import { recallKey, type SessionManifest } from "./manifest";

/** Build the client-facing manifest at build time (server components only). */
export function buildSessionManifest(): SessionManifest {
  const concepts: SessionManifest["concepts"] = {};
  for (const c of allConcepts) {
    concepts[c.id] = {
      id: c.id,
      title: c.title,
      domain: c.domain,
      difficulty: c.difficulty,
      availableLevels: allConceptLevels
        .filter((l) => l.conceptId === c.id)
        .map((l) => l.level)
        .sort((a, b) => a - b),
    };
  }

  const recalls: SessionManifest["recalls"] = {};
  for (const level of allConceptLevels) {
    if (level.recall) {
      recalls[recallKey(level.conceptId, level.level)] = level.recall;
    }
  }

  const questions: SessionManifest["questions"] = allQuizzes.flatMap((bank) =>
    bank.questions.map((q) => ({ ...q, domain: bank.domain })),
  );

  return { concepts, recalls, questions };
}
