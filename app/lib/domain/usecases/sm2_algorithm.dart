import 'dart:math';

/// SM-2 spaced repetition algorithm result.
class Sm2Result {
  final double easeFactor;
  final int interval;
  final int repetitions;
  final DateTime nextReviewDate;

  const Sm2Result({
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.nextReviewDate,
  });
}

/// Modified SM-2 algorithm with confidence calibration adjustment.
///
/// quality: 0-5 (0=complete blackout, 5=perfect recall)
/// confidence: 1-5 (self-rated confidence before/after reveal)
/// overconfidenceRate: 0.0-1.0 (historical rate of being wrong when confident)
class Sm2Algorithm {
  const Sm2Algorithm();

  Sm2Result calculate({
    required int quality,
    required double easeFactor,
    required int interval,
    required int repetitions,
    double? overconfidenceRate,
  }) {
    int newInterval;
    int newRepetitions;
    double newEaseFactor;

    if (quality >= 3) {
      // Successful recall
      if (repetitions == 0) {
        newInterval = 1;
      } else if (repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * easeFactor).round();
      }
      newRepetitions = repetitions + 1;
    } else {
      // Failed recall — reset
      newRepetitions = 0;
      newInterval = 1;
    }

    // Update ease factor
    newEaseFactor = easeFactor +
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    newEaseFactor = max(1.3, newEaseFactor);

    // Confidence calibration adjustment:
    // If user is historically overconfident in this domain,
    // shorten intervals to force more frequent review.
    if (overconfidenceRate != null && overconfidenceRate > 0.3) {
      final reduction = 1.0 - (overconfidenceRate - 0.3) * 0.5;
      newInterval = (newInterval * reduction).round();
      newInterval = max(1, newInterval);
    }

    final nextReviewDate =
        DateTime.now().add(Duration(days: newInterval));

    return Sm2Result(
      easeFactor: newEaseFactor,
      interval: newInterval,
      repetitions: newRepetitions,
      nextReviewDate: nextReviewDate,
    );
  }
}
