import '../entities/user_progress.dart';

/// Result of confidence calibration analysis.
class CalibrationResult {
  /// Rate of being correct when user said "confident" (confidence >= 4).
  final double highConfidenceAccuracy;

  /// Rate of being correct when user said "not confident" (confidence <= 2).
  final double lowConfidenceAccuracy;

  /// Overall calibration score (1.0 = perfectly calibrated).
  /// > 1.0 means overconfident, < 1.0 means underconfident.
  final double calibrationRatio;

  /// True if user is systematically overconfident.
  bool get isOverconfident => calibrationRatio > 1.2;

  /// True if user is systematically underconfident.
  bool get isUnderconfident => calibrationRatio < 0.8;

  const CalibrationResult({
    required this.highConfidenceAccuracy,
    required this.lowConfidenceAccuracy,
    required this.calibrationRatio,
  });
}

/// Analyzes confidence calibration from historical logs.
class ConfidenceCalibration {
  const ConfidenceCalibration();

  CalibrationResult analyze(List<ConfidenceLog> logs) {
    if (logs.isEmpty) {
      return const CalibrationResult(
        highConfidenceAccuracy: 0.0,
        lowConfidenceAccuracy: 0.0,
        calibrationRatio: 1.0,
      );
    }

    // High confidence logs (confidence >= 4)
    final highConfLogs = logs.where((l) => l.confidence >= 4).toList();
    final highConfCorrect =
        highConfLogs.where((l) => l.quality >= 3).length;
    final highConfAccuracy = highConfLogs.isNotEmpty
        ? highConfCorrect / highConfLogs.length
        : 0.0;

    // Low confidence logs (confidence <= 2)
    final lowConfLogs = logs.where((l) => l.confidence <= 2).toList();
    final lowConfCorrect =
        lowConfLogs.where((l) => l.quality >= 3).length;
    final lowConfAccuracy = lowConfLogs.isNotEmpty
        ? lowConfCorrect / lowConfLogs.length
        : 0.0;

    // Calibration ratio: average confidence / average quality (normalized)
    final avgConfidence =
        logs.map((l) => l.confidence).reduce((a, b) => a + b) /
            logs.length /
            5.0; // normalize to 0-1
    final avgQuality =
        logs.map((l) => l.quality).reduce((a, b) => a + b) /
            logs.length /
            5.0; // normalize to 0-1
    final calibrationRatio =
        avgQuality > 0 ? avgConfidence / avgQuality : 1.0;

    return CalibrationResult(
      highConfidenceAccuracy: highConfAccuracy,
      lowConfidenceAccuracy: lowConfAccuracy,
      calibrationRatio: calibrationRatio,
    );
  }

  /// Per-domain overconfidence rate (for SM-2 interval adjustment).
  double overconfidenceRate(List<ConfidenceLog> domainLogs) {
    final highConfLogs = domainLogs.where((l) => l.confidence >= 4).toList();
    if (highConfLogs.length < 5) return 0.0; // not enough data
    final incorrect = highConfLogs.where((l) => l.quality < 3).length;
    return incorrect / highConfLogs.length;
  }
}
