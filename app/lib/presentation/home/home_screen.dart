import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/user_progress.dart';
import '../shared/loading_indicator.dart';
import 'widgets/streak_card.dart';
import 'widgets/domain_mastery_bars.dart';
import 'widgets/at_risk_concepts.dart';

/// Provider for home screen data.
final homeDataProvider = FutureProvider<HomeData>((ref) async {
  final progressRepo = ref.watch(progressRepositoryProvider);
  final reviewRepo = ref.watch(reviewRepositoryProvider);
  final conceptRepo = ref.watch(conceptRepositoryProvider);

  final stats = await progressRepo.getUserStats();
  final domainMastery = await progressRepo.getAllDomainMastery();
  final dueCards = await reviewRepo.getDueCards(DateTime.now());
  final atRiskCards = await reviewRepo.getAtRiskCards(daysAhead: 7);

  // Resolve concept titles for at-risk cards
  final atRiskConcepts = <AtRiskConcept>[];
  for (final card in atRiskCards.take(5)) {
    final concept = await conceptRepo.getConceptById(card.conceptId);
    if (concept != null) {
      atRiskConcepts.add(AtRiskConcept(
        conceptId: concept.id,
        title: concept.title,
        tags: concept.tags,
        dueDate: card.nextReviewDate,
      ));
    }
  }

  return HomeData(
    stats: stats,
    domainMastery: domainMastery,
    dueCount: dueCards.length,
    atRiskConcepts: atRiskConcepts,
  );
});

class HomeData {
  final UserStats stats;
  final List<DomainMastery> domainMastery;
  final int dueCount;
  final List<AtRiskConcept> atRiskConcepts;

  const HomeData({
    required this.stats,
    required this.domainMastery,
    required this.dueCount,
    required this.atRiskConcepts,
  });
}

class AtRiskConcept {
  final String conceptId;
  final String title;
  final List<String> tags;
  final DateTime dueDate;

  const AtRiskConcept({
    required this.conceptId,
    required this.title,
    required this.tags,
    required this.dueDate,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInit = ref.watch(appInitProvider);

    return appInit.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (e, s) => Scaffold(
        body: Center(child: Text('Error initializing: $e')),
      ),
      data: (_) => _HomeContent(),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CORTEX'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: homeData.when(
        loading: () => const LoadingIndicator(),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (data) => _buildContent(context, data),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Streak + Start Session card
          StreakCard(
            streak: data.stats.currentStreak,
            dueCount: data.dueCount,
            onStartSession: () => context.push(AppRoutes.session),
          ),
          const SizedBox(height: 24),

          // Domain mastery
          Text(
            'Domain Mastery',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DomainMasteryBars(domains: data.domainMastery),
          const SizedBox(height: 24),

          // At-risk concepts
          if (data.atRiskConcepts.isNotEmpty) ...[
            Text(
              'At Risk (forgetting soon)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.warning,
                  ),
            ),
            const SizedBox(height: 12),
            AtRiskConcepts(concepts: data.atRiskConcepts),
            const SizedBox(height: 24),
          ],

          // Quick actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickAction(
                icon: Icons.format_list_bulleted,
                label: 'Review Queue',
                onTap: () => context.push(AppRoutes.reviewQueue),
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.quiz_outlined,
                label: 'Quiz',
                onTap: () => context.push(AppRoutes.quiz),
              ),
              const SizedBox(width: 12),
              _QuickAction(
                icon: Icons.insights,
                label: 'Progress',
                onTap: () => context.push(AppRoutes.progress),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
