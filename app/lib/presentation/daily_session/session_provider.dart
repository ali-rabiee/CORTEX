import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_config.dart';
import '../../domain/entities/concept.dart';
import '../../domain/entities/review_card.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/session_config.dart';
import '../../domain/entities/user_progress.dart';

/// Current session state.
enum SessionStatus { loading, warmup, coreReview, challenge, cooldown, finished }

class SessionState {
  final SessionStatus status;
  final List<ReviewCard> warmupCards;
  final List<ReviewCard> coreCards;
  final List<QuizQuestion> challengeQuestions;
  final Map<String, Concept> conceptMap;
  final int currentIndex;
  final bool cardRevealed;
  final int cardsReviewed;
  final int quizCorrect;
  final int quizTotal;
  final List<int> qualityRatings;
  final String? errorMessage;

  const SessionState({
    this.status = SessionStatus.loading,
    this.warmupCards = const [],
    this.coreCards = const [],
    this.challengeQuestions = const [],
    this.conceptMap = const {},
    this.currentIndex = 0,
    this.cardRevealed = false,
    this.cardsReviewed = 0,
    this.quizCorrect = 0,
    this.quizTotal = 0,
    this.qualityRatings = const [],
    this.errorMessage,
  });

  SessionState copyWith({
    SessionStatus? status,
    List<ReviewCard>? warmupCards,
    List<ReviewCard>? coreCards,
    List<QuizQuestion>? challengeQuestions,
    Map<String, Concept>? conceptMap,
    int? currentIndex,
    bool? cardRevealed,
    int? cardsReviewed,
    int? quizCorrect,
    int? quizTotal,
    List<int>? qualityRatings,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      warmupCards: warmupCards ?? this.warmupCards,
      coreCards: coreCards ?? this.coreCards,
      challengeQuestions: challengeQuestions ?? this.challengeQuestions,
      conceptMap: conceptMap ?? this.conceptMap,
      currentIndex: currentIndex ?? this.currentIndex,
      cardRevealed: cardRevealed ?? this.cardRevealed,
      cardsReviewed: cardsReviewed ?? this.cardsReviewed,
      quizCorrect: quizCorrect ?? this.quizCorrect,
      quizTotal: quizTotal ?? this.quizTotal,
      qualityRatings: qualityRatings ?? this.qualityRatings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Current cards for the active phase.
  List<ReviewCard> get currentPhaseCards {
    switch (status) {
      case SessionStatus.warmup:
        return warmupCards;
      case SessionStatus.coreReview:
        return coreCards;
      default:
        return [];
    }
  }

  /// Total card count across warmup + core.
  int get totalReviewCards => warmupCards.length + coreCards.length;

  /// Progress through the current phase (0.0 - 1.0).
  double get phaseProgress {
    final cards = currentPhaseCards;
    if (cards.isEmpty) return 0.0;
    return currentIndex / cards.length;
  }

  double get averageQuality {
    if (qualityRatings.isEmpty) return 0.0;
    return qualityRatings.reduce((a, b) => a + b) / qualityRatings.length;
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  final Ref _ref;

  SessionNotifier(this._ref) : super(const SessionState()) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    try {
      final reviewRepo = _ref.read(reviewRepositoryProvider);
      final conceptRepo = _ref.read(conceptRepositoryProvider);
      final quizRepo = _ref.read(quizRepositoryProvider);
      final generator = _ref.read(generateSessionProvider);

      final dueCards = await reviewRepo.getDueCards(DateTime.now());
      final easyCards = await reviewRepo.getEasyCards(limit: 10);
      final allQuizzes = await quizRepo.getAllQuestions();
      final allConcepts = await conceptRepo.getAllConcepts();

      final conceptMap = {for (final c in allConcepts) c.id: c};

      final session = generator.call(
        dueCards: dueCards,
        easyCards: easyCards,
        availableQuizzes: allQuizzes,
        conceptMap: conceptMap,
      );

      state = state.copyWith(
        status: session.warmupCards.isNotEmpty
            ? SessionStatus.warmup
            : (session.coreCards.isNotEmpty
                ? SessionStatus.coreReview
                : SessionStatus.challenge),
        warmupCards: session.warmupCards,
        coreCards: session.coreCards,
        challengeQuestions: session.challengeQuestions,
        conceptMap: conceptMap,
        currentIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(
        status: SessionStatus.finished,
        errorMessage: e.toString(),
      );
    }
  }

  void revealCard() {
    state = state.copyWith(cardRevealed: true);
  }

  Future<void> rateCard(int quality, int confidence) async {
    final cards = state.currentPhaseCards;
    if (state.currentIndex >= cards.length) return;

    final card = cards[state.currentIndex];
    final sm2 = _ref.read(sm2AlgorithmProvider);
    final reviewRepo = _ref.read(reviewRepositoryProvider);

    // Calculate new SM-2 values
    final result = sm2.calculate(
      quality: quality,
      easeFactor: card.easeFactor,
      interval: card.interval,
      repetitions: card.repetitions,
    );

    // Update review card
    final updatedCard = ReviewCard(
      id: card.id,
      conceptId: card.conceptId,
      easeFactor: result.easeFactor,
      interval: result.interval,
      nextReviewDate: result.nextReviewDate,
      repetitions: result.repetitions,
      lastQuality: quality,
    );
    await reviewRepo.updateCard(updatedCard);

    // Log confidence
    await reviewRepo.logConfidence(ConfidenceLog(
      id: 0,
      conceptId: card.conceptId,
      confidence: confidence,
      quality: quality,
      timestamp: DateTime.now(),
    ));

    final nextIndex = state.currentIndex + 1;
    final newRatings = [...state.qualityRatings, quality];

    if (nextIndex >= cards.length) {
      // Move to next phase
      _advancePhase(newRatings);
    } else {
      state = state.copyWith(
        currentIndex: nextIndex,
        cardRevealed: false,
        cardsReviewed: state.cardsReviewed + 1,
        qualityRatings: newRatings,
      );
    }
  }

  void _advancePhase(List<int> ratings) {
    switch (state.status) {
      case SessionStatus.warmup:
        state = state.copyWith(
          status: state.coreCards.isNotEmpty
              ? SessionStatus.coreReview
              : SessionStatus.challenge,
          currentIndex: 0,
          cardRevealed: false,
          cardsReviewed: state.cardsReviewed + 1,
          qualityRatings: ratings,
        );
        break;
      case SessionStatus.coreReview:
        state = state.copyWith(
          status: state.challengeQuestions.isNotEmpty
              ? SessionStatus.challenge
              : SessionStatus.cooldown,
          currentIndex: 0,
          cardRevealed: false,
          cardsReviewed: state.cardsReviewed + 1,
          qualityRatings: ratings,
        );
        break;
      case SessionStatus.challenge:
        state = state.copyWith(
          status: SessionStatus.cooldown,
          qualityRatings: ratings,
        );
        break;
      default:
        state = state.copyWith(
          status: SessionStatus.finished,
          qualityRatings: ratings,
        );
    }
  }

  void answerQuiz(int selectedAnswer, bool correct) {
    final newQuizTotal = state.quizTotal + 1;
    final newQuizCorrect = state.quizCorrect + (correct ? 1 : 0);
    final nextIndex = state.currentIndex + 1;

    if (nextIndex >= state.challengeQuestions.length) {
      state = state.copyWith(
        status: SessionStatus.cooldown,
        quizCorrect: newQuizCorrect,
        quizTotal: newQuizTotal,
        currentIndex: nextIndex,
      );
    } else {
      state = state.copyWith(
        quizCorrect: newQuizCorrect,
        quizTotal: newQuizTotal,
        currentIndex: nextIndex,
      );
    }
  }

  Future<void> finishSession() async {
    final progressRepo = _ref.read(progressRepositoryProvider);

    await progressRepo.updateStreak();
    await progressRepo.logSession(SessionResult(
      cardsReviewed: state.cardsReviewed,
      quizCorrect: state.quizCorrect,
      quizTotal: state.quizTotal,
      durationMinutes: 0, // TODO: track actual duration
      averageQuality: state.averageQuality,
      date: DateTime.now(),
    ));

    state = state.copyWith(status: SessionStatus.finished);
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref);
});
