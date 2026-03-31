import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/usecases/confidence_calibration.dart';

/// Shows confidence calibration analysis.
class CalibrationCard extends StatelessWidget {
  final CalibrationResult calibration;

  const CalibrationCard({super.key, required this.calibration});

  @override
  Widget build(BuildContext context) {
    final highPct = (calibration.highConfidenceAccuracy * 100).round();
    final lowPct = (calibration.lowConfidenceAccuracy * 100).round();

    String verdict;
    Color verdictColor;
    if (calibration.isOverconfident) {
      verdict = 'You tend to be overconfident. Review more carefully.';
      verdictColor = AppColors.warning;
    } else if (calibration.isUnderconfident) {
      verdict = 'You tend to underestimate yourself. You know more than you think.';
      verdictColor = AppColors.info;
    } else {
      verdict = 'Your confidence is well-calibrated. Keep it up.';
      verdictColor = AppColors.success;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: verdictColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  verdict,
                  style: TextStyle(
                    color: verdictColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CalibrationRow(
            label: 'Said "confident" and was correct',
            value: '$highPct%',
          ),
          const SizedBox(height: 6),
          _CalibrationRow(
            label: 'Said "unsure" and was correct',
            value: '$lowPct%',
          ),
        ],
      ),
    );
  }
}

class _CalibrationRow extends StatelessWidget {
  final String label;
  final String value;

  const _CalibrationRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
