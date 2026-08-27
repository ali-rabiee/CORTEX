/**
 * Confidence calibration analysis. Port of
 * `app/lib/domain/usecases/confidence_calibration.dart`.
 */

export type ConfidenceLog = {
  /** Self-rated confidence 1–5, recorded before the answer is revealed. */
  confidence: number;
  /** Recall quality 0–5, rated after the reveal. */
  quality: number;
};

export type CalibrationResult = {
  /** Accuracy when confident (confidence ≥ 4). */
  highConfidenceAccuracy: number;
  /** Accuracy when not confident (confidence ≤ 2). */
  lowConfidenceAccuracy: number;
  /** avgConfidence / avgQuality (both normalized). 1.0 = calibrated. */
  calibrationRatio: number;
  isOverconfident: boolean;
  isUnderconfident: boolean;
};

export function analyzeCalibration(logs: ConfidenceLog[]): CalibrationResult {
  if (logs.length === 0) {
    return {
      highConfidenceAccuracy: 0,
      lowConfidenceAccuracy: 0,
      calibrationRatio: 1,
      isOverconfident: false,
      isUnderconfident: false,
    };
  }

  const highConf = logs.filter((l) => l.confidence >= 4);
  const highConfidenceAccuracy =
    highConf.length > 0
      ? highConf.filter((l) => l.quality >= 3).length / highConf.length
      : 0;

  const lowConf = logs.filter((l) => l.confidence <= 2);
  const lowConfidenceAccuracy =
    lowConf.length > 0
      ? lowConf.filter((l) => l.quality >= 3).length / lowConf.length
      : 0;

  const avgConfidence =
    logs.reduce((sum, l) => sum + l.confidence, 0) / logs.length / 5;
  const avgQuality =
    logs.reduce((sum, l) => sum + l.quality, 0) / logs.length / 5;
  const calibrationRatio = avgQuality > 0 ? avgConfidence / avgQuality : 1;

  return {
    highConfidenceAccuracy,
    lowConfidenceAccuracy,
    calibrationRatio,
    isOverconfident: calibrationRatio > 1.2,
    isUnderconfident: calibrationRatio < 0.8,
  };
}

/** Per-domain overconfidence rate, fed into SM-2 interval adjustment.
 * Returns 0 until there are at least 5 high-confidence answers. */
export function overconfidenceRate(domainLogs: ConfidenceLog[]): number {
  const highConf = domainLogs.filter((l) => l.confidence >= 4);
  if (highConf.length < 5) return 0;
  return highConf.filter((l) => l.quality < 3).length / highConf.length;
}
