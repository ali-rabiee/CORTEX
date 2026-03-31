import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Shows current streak and due review count with start session CTA.
class StreakCard extends StatelessWidget {
  final int streak;
  final int dueCount;
  final VoidCallback onStartSession;

  const StreakCard({
    super.key,
    required this.streak,
    required this.dueCount,
    required this.onStartSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department,
                  color: AppColors.warning, size: 28),
              const SizedBox(width: 8),
              Text(
                '$streak-day streak',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dueCount > 0
                ? 'Today: $dueCount reviews due'
                : 'All caught up! Start a practice session.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStartSession,
              child: Text(
                dueCount > 0 ? 'Start Daily Session' : 'Practice Session',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
