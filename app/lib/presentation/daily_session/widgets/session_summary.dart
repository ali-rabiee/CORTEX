import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// End-of-session summary showing performance stats.
class SessionSummary extends StatelessWidget {
  final int cardsReviewed;
  final int quizCorrect;
  final int quizTotal;
  final double averageQuality;
  final VoidCallback onFinish;

  const SessionSummary({
    super.key,
    required this.cardsReviewed,
    required this.quizCorrect,
    required this.quizTotal,
    required this.averageQuality,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final quizPct =
        quizTotal > 0 ? ((quizCorrect / quizTotal) * 100).round() : 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 64,
          ),
          const SizedBox(height: 20),
          const Text(
            'Session Complete',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),
          _StatRow(label: 'Cards Reviewed', value: '$cardsReviewed'),
          _StatRow(
            label: 'Average Quality',
            value: averageQuality.toStringAsFixed(1),
          ),
          if (quizTotal > 0)
            _StatRow(
              label: 'Quiz Accuracy',
              value: '$quizCorrect/$quizTotal ($quizPct%)',
            ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFinish,
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
