import '../entities/review_card.dart';
import '../entities/user_progress.dart';

/// Calculates domain mastery score from review card performance.
class CalculateMastery {
  const CalculateMastery();

  /// Mastery score (0.0 - 1.0) based on ease factors and review success.
  ///
  /// Factors:
  /// - Average ease factor (normalized from 1.3-3.0 range to 0-1)
  /// - Percentage of cards with interval > 7 days (stable knowledge)
  /// - Quiz accuracy for the domain
  double call({
    required List<ReviewCard> domainCards,
    required DomainMastery domainProgress,
  }) {
    if (domainCards.isEmpty) return 0.0;

    // Factor 1: Average ease factor (weight: 40%)
    final avgEase = domainCards
            .map((c) => c.easeFactor)
            .reduce((a, b) => a + b) /
        domainCards.length;
    final easeScore = ((avgEase - 1.3) / (3.0 - 1.3)).clamp(0.0, 1.0);

    // Factor 2: Stable knowledge ratio (weight: 35%)
    final stableCards = domainCards.where((c) => c.interval > 7).length;
    final stabilityScore = stableCards / domainCards.length;

    // Factor 3: Quiz accuracy (weight: 25%)
    final quizScore = domainProgress.totalQuizAnswers > 0
        ? domainProgress.correctQuizAnswers / domainProgress.totalQuizAnswers
        : 0.0;

    return (easeScore * 0.4 + stabilityScore * 0.35 + quizScore * 0.25)
        .clamp(0.0, 1.0);
  }
}
