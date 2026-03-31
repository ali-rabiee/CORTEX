import '../entities/review_card.dart';
import '../entities/user_progress.dart';

/// Interface for review card and confidence data access.
abstract class ReviewRepository {
  Future<List<ReviewCard>> getDueCards(DateTime asOf);
  Future<List<ReviewCard>> getEasyCards({int limit = 10});
  Future<List<ReviewCard>> getCardsByDomain(String domain);
  Future<ReviewCard?> getCardByConceptId(String conceptId);
  Future<void> updateCard(ReviewCard card);
  Future<void> insertCard(ReviewCard card);
  Future<void> insertCards(List<ReviewCard> cards);
  Future<List<ReviewCard>> getAllCards();

  Future<void> logConfidence(ConfidenceLog log);
  Future<List<ConfidenceLog>> getConfidenceLogs({String? domain, int? limit});

  /// Concepts with SM-2 intervals decaying within the given window.
  Future<List<ReviewCard>> getAtRiskCards({int daysAhead = 7});
}
