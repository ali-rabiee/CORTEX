import '../entities/concept.dart';
import '../entities/review_card.dart';
import '../entities/quiz_question.dart';
import '../entities/session_config.dart';

/// A generated daily session with cards organized by phase.
class GeneratedSession {
  final List<ReviewCard> warmupCards;
  final List<ReviewCard> coreCards;
  final List<QuizQuestion> challengeQuestions;
  final SessionConfig config;

  const GeneratedSession({
    required this.warmupCards,
    required this.coreCards,
    required this.challengeQuestions,
    required this.config,
  });

  int get totalCards => warmupCards.length + coreCards.length;
  int get totalQuestions => challengeQuestions.length;
}

/// Generates a structured daily session from available review cards and quizzes.
class GenerateSession {
  const GenerateSession();

  GeneratedSession call({
    required List<ReviewCard> dueCards,
    required List<ReviewCard> easyCards,
    required List<QuizQuestion> availableQuizzes,
    required Map<String, Concept> conceptMap,
    SessionConfig config = const SessionConfig(),
  }) {
    // Phase 1: Warmup — pick easy cards the user knows well
    final warmup = _selectWarmupCards(easyCards, config.warmupCards);

    // Phase 2: Core — due review cards, interleaved across domains
    final core = _selectCoreCards(
      dueCards,
      conceptMap,
      config.coreReviewCards,
    );

    // Phase 3: Challenge — quiz questions related to today's reviewed concepts
    final reviewedConceptIds = {
      ...warmup.map((c) => c.conceptId),
      ...core.map((c) => c.conceptId),
    };

    final challenge = _selectChallengeQuestions(
      availableQuizzes,
      reviewedConceptIds,
      config.challengeQuestions,
    );

    return GeneratedSession(
      warmupCards: warmup,
      coreCards: core,
      challengeQuestions: challenge,
      config: config,
    );
  }

  List<ReviewCard> _selectWarmupCards(
    List<ReviewCard> easyCards,
    int count,
  ) {
    // Sort by highest ease factor (strongest knowledge)
    final sorted = [...easyCards]
      ..sort((a, b) => b.easeFactor.compareTo(a.easeFactor));
    return sorted.take(count).toList();
  }

  List<ReviewCard> _selectCoreCards(
    List<ReviewCard> dueCards,
    Map<String, Concept> conceptMap,
    int maxCount,
  ) {
    if (dueCards.length <= maxCount) return dueCards;

    // Interleave across domains for better retention
    final byDomain = <String, List<ReviewCard>>{};
    for (final card in dueCards) {
      final concept = conceptMap[card.conceptId];
      final domain =
          (concept != null && concept.tags.isNotEmpty) ? concept.tags.first : 'unknown';
      byDomain.putIfAbsent(domain, () => <ReviewCard>[]).add(card);
    }

    final result = <ReviewCard>[];
    var added = true;
    while (result.length < maxCount && added) {
      added = false;
      for (final domain in byDomain.keys) {
        if (result.length >= maxCount) break;
        final cards = byDomain[domain]!;
        if (cards.isNotEmpty) {
          result.add(cards.removeAt(0));
          added = true;
        }
      }
    }

    return result;
  }

  List<QuizQuestion> _selectChallengeQuestions(
    List<QuizQuestion> available,
    Set<String> reviewedConceptIds,
    int count,
  ) {
    // Prefer questions related to today's reviewed concepts
    final related = available.where((q) {
      return q.conceptIds.any((id) => reviewedConceptIds.contains(id));
    }).toList();

    final unrelated = available.where((q) {
      return !q.conceptIds.any((id) => reviewedConceptIds.contains(id));
    }).toList();

    final result = <QuizQuestion>[];
    result.addAll(related.take(count));
    if (result.length < count) {
      result.addAll(unrelated.take(count - result.length));
    }

    return result;
  }
}
