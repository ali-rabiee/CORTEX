import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/concept.dart';
import '../../domain/entities/review_card.dart' as entity;
import '../shared/domain_tag_chip.dart';
import '../shared/loading_indicator.dart';

class _ReviewQueueData {
  final List<_ReviewItem> dueNow;
  final List<_ReviewItem> upcoming;
  const _ReviewQueueData({required this.dueNow, required this.upcoming});
}

class _ReviewItem {
  final entity.ReviewCard card;
  final Concept concept;
  const _ReviewItem({required this.card, required this.concept});
}

final reviewQueueDataProvider =
    FutureProvider<_ReviewQueueData>((ref) async {
  final reviewRepo = ref.watch(reviewRepositoryProvider);
  final conceptRepo = ref.watch(conceptRepositoryProvider);

  final now = DateTime.now();
  final dueCards = await reviewRepo.getDueCards(now);
  final allCards = await reviewRepo.getAllCards();

  Future<_ReviewItem?> toItem(entity.ReviewCard card) async {
    final concept = await conceptRepo.getConceptById(card.conceptId);
    if (concept == null) return null;
    return _ReviewItem(card: card, concept: concept);
  }

  final dueItems = (await Future.wait(dueCards.map(toItem)))
      .whereType<_ReviewItem>()
      .toList();

  final upcomingCards =
      allCards.where((c) => c.nextReviewDate.isAfter(now)).toList()
        ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));

  final upcomingItems =
      (await Future.wait(upcomingCards.take(20).map(toItem)))
          .whereType<_ReviewItem>()
          .toList();

  return _ReviewQueueData(dueNow: dueItems, upcoming: upcomingItems);
});

class ReviewQueueScreen extends ConsumerWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(reviewQueueDataProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Review Queue')),
      body: data.when(
        loading: () => const LoadingIndicator(),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (queue) => _buildContent(context, queue),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _ReviewQueueData queue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Due Now (${queue.dueNow.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (queue.dueNow.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No reviews due right now. Nice work!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ...queue.dueNow.map((item) => _ReviewTile(item: item)),
          const SizedBox(height: 24),
          Text(
            'Coming Up',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (queue.upcoming.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No upcoming reviews.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            ...queue.upcoming.map((item) => _ReviewTile(item: item)),
          const SizedBox(height: 24),
          if (queue.dueNow.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.session),
                child: const Text('Start Review Session'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final _ReviewItem item;

  const _ReviewTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final daysUntil =
        item.card.nextReviewDate.difference(DateTime.now()).inDays;
    final dueText = daysUntil <= 0
        ? 'Due today'
        : daysUntil == 1
            ? 'Due tomorrow'
            : 'Due in $daysUntil days';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => context.push('/concept/${item.concept.id}'),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.concept.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueText,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: item.concept.tags
                    .take(1)
                    .map((t) => DomainTagChip(tag: t))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
