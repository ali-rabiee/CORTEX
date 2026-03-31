import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/usecases/confidence_calibration.dart';
import '../shared/loading_indicator.dart';
import 'widgets/mastery_chart.dart';
import 'widgets/calibration_card.dart';
import 'widgets/weakness_list.dart';

class _ProgressData {
  final UserStats stats;
  final List<DomainMastery> domains;
  final CalibrationResult calibration;
  final List<String> weakConceptTitles;

  const _ProgressData({
    required this.stats,
    required this.domains,
    required this.calibration,
    required this.weakConceptTitles,
  });
}

final progressDataProvider = FutureProvider<_ProgressData>((ref) async {
  final progressRepo = ref.watch(progressRepositoryProvider);
  final reviewRepo = ref.watch(reviewRepositoryProvider);
  final conceptRepo = ref.watch(conceptRepositoryProvider);
  final calibrationUseCase = ref.watch(confidenceCalibrationProvider);

  final stats = await progressRepo.getUserStats();
  final domains = await progressRepo.getAllDomainMastery();
  final confLogs = await reviewRepo.getConfidenceLogs(limit: 200);
  final calibration = calibrationUseCase.analyze(confLogs);

  // Find weakest concepts: lowest ease factor cards
  final allCards = await reviewRepo.getAllCards();
  final weakCards = [...allCards]
    ..sort((a, b) => a.easeFactor.compareTo(b.easeFactor));
  final weakTitles = <String>[];
  for (final card in weakCards.take(5)) {
    final concept = await conceptRepo.getConceptById(card.conceptId);
    if (concept != null) weakTitles.add(concept.title);
  }

  return _ProgressData(
    stats: stats,
    domains: domains,
    calibration: calibration,
    weakConceptTitles: weakTitles,
  );
});

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(progressDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: data.when(
        loading: () => const LoadingIndicator(),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (d) => _buildContent(context, d),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _ProgressData data) {
    final overallMastery = data.domains.isEmpty
        ? 0.0
        : data.domains.map((d) => d.masteryScore).reduce((a, b) => a + b) /
            data.domains.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview stats
          _OverviewCard(
            mastery: overallMastery,
            streak: data.stats.currentStreak,
            totalReviews: data.stats.totalReviews,
            totalSessions: data.stats.totalSessions,
          ),
          const SizedBox(height: 24),

          // Domain mastery chart
          Text(
            'Domain Breakdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          MasteryChart(domains: data.domains),
          const SizedBox(height: 24),

          // Confidence calibration
          Text(
            'Confidence Calibration',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          CalibrationCard(calibration: data.calibration),
          const SizedBox(height: 24),

          // Weakest concepts
          if (data.weakConceptTitles.isNotEmpty) ...[
            Text(
              'Weakest Concepts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            WeaknessList(titles: data.weakConceptTitles),
          ],
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final double mastery;
  final int streak;
  final int totalReviews;
  final int totalSessions;

  const _OverviewCard({
    required this.mastery,
    required this.streak,
    required this.totalReviews,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          Text(
            '${(mastery * 100).round()}%',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 48,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'Overall Mastery',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MiniStat(
                  value: '$streak', label: 'Streak', icon: Icons.local_fire_department),
              _MiniStat(
                  value: '$totalReviews', label: 'Reviews', icon: Icons.rate_review),
              _MiniStat(
                  value: '$totalSessions', label: 'Sessions', icon: Icons.calendar_today),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textMuted, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
