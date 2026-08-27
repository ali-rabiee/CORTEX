/**
 * Daily session generator. Port of
 * `app/lib/domain/usecases/generate_session.dart`: warmup (strongest cards),
 * core (due cards interleaved across domains), challenge (quiz questions
 * biased toward today's reviewed concepts).
 */

export type SessionCard = {
  conceptId: string;
  easeFactor: number;
};

export type SessionQuizQuestion = {
  id: string;
  concept_ids: string[];
};

export type SessionConfig = {
  warmupCards: number;
  coreReviewCards: number;
  challengeQuestions: number;
};

export type GeneratedSession<
  TCard extends SessionCard,
  TQuestion extends SessionQuizQuestion,
> = {
  warmupCards: TCard[];
  coreCards: TCard[];
  challengeQuestions: TQuestion[];
  config: SessionConfig;
};

export function generateSession<
  TCard extends SessionCard,
  TQuestion extends SessionQuizQuestion,
>({
  dueCards,
  easyCards,
  availableQuestions,
  domainOf,
  config,
}: {
  dueCards: TCard[];
  easyCards: TCard[];
  availableQuestions: TQuestion[];
  /** Maps a conceptId to its domain, for interleaving. */
  domainOf: (conceptId: string) => string;
  config: SessionConfig;
}): GeneratedSession<TCard, TQuestion> {
  const warmup = selectWarmup(easyCards, config.warmupCards);
  const core = selectCore(dueCards, domainOf, config.coreReviewCards);

  const reviewedIds = new Set([
    ...warmup.map((c) => c.conceptId),
    ...core.map((c) => c.conceptId),
  ]);
  const challenge = selectChallenge(
    availableQuestions,
    reviewedIds,
    config.challengeQuestions,
  );

  return { warmupCards: warmup, coreCards: core, challengeQuestions: challenge, config };
}

function selectWarmup<TCard extends SessionCard>(
  easyCards: TCard[],
  count: number,
): TCard[] {
  return [...easyCards]
    .sort((a, b) => b.easeFactor - a.easeFactor)
    .slice(0, count);
}

function selectCore<TCard extends SessionCard>(
  dueCards: TCard[],
  domainOf: (conceptId: string) => string,
  maxCount: number,
): TCard[] {
  if (dueCards.length <= maxCount) return dueCards;

  const byDomain = new Map<string, TCard[]>();
  for (const card of dueCards) {
    const domain = domainOf(card.conceptId);
    const list = byDomain.get(domain) ?? [];
    list.push(card);
    byDomain.set(domain, list);
  }

  const result: TCard[] = [];
  let added = true;
  while (result.length < maxCount && added) {
    added = false;
    for (const cards of byDomain.values()) {
      if (result.length >= maxCount) break;
      const next = cards.shift();
      if (next) {
        result.push(next);
        added = true;
      }
    }
  }
  return result;
}

function selectChallenge<TQuestion extends SessionQuizQuestion>(
  available: TQuestion[],
  reviewedConceptIds: Set<string>,
  count: number,
): TQuestion[] {
  const related = available.filter((q) =>
    q.concept_ids.some((id) => reviewedConceptIds.has(id)),
  );
  const unrelated = available.filter(
    (q) => !q.concept_ids.some((id) => reviewedConceptIds.has(id)),
  );
  const result = related.slice(0, count);
  if (result.length < count) {
    result.push(...unrelated.slice(0, count - result.length));
  }
  return result;
}
