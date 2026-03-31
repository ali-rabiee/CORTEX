import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/concept.dart';
import '../../domain/entities/review_card.dart';
import '../shared/domain_tag_chip.dart';
import '../shared/difficulty_stars.dart';
import '../shared/loading_indicator.dart';

final conceptDetailProvider =
    FutureProvider.family<_ConceptDetail?, String>((ref, id) async {
  final conceptRepo = ref.watch(conceptRepositoryProvider);
  final reviewRepo = ref.watch(reviewRepositoryProvider);

  final concept = await conceptRepo.getConceptById(id);
  if (concept == null) return null;

  final reviewCard = await reviewRepo.getCardByConceptId(id);
  return _ConceptDetail(concept: concept, reviewCard: reviewCard);
});

class _ConceptDetail {
  final Concept concept;
  final ReviewCard? reviewCard;
  const _ConceptDetail({required this.concept, this.reviewCard});
}

class ConceptDetailScreen extends ConsumerWidget {
  final String conceptId;

  const ConceptDetailScreen({super.key, required this.conceptId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(conceptDetailProvider(conceptId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: detail.when(
        loading: () => const LoadingIndicator(),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Concept not found'));
          }
          return _buildContent(context, data);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, _ConceptDetail detail) {
    final concept = detail.concept;
    final card = detail.reviewCard;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Wrap(
            spacing: 6,
            children: concept.tags.map((t) => DomainTagChip(tag: t)).toList(),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            concept.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Difficulty + Importance
          Row(
            children: [
              const Text('Difficulty: ',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              DifficultyStars(level: concept.difficulty),
              const SizedBox(width: 20),
              const Text('Importance: ',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              DifficultyStars(level: concept.importance),
            ],
          ),
          const SizedBox(height: 24),

          _Section(title: 'Definition', content: concept.definition),
          _Section(title: 'Intuition', content: concept.intuition),
          _Section(
              title: 'Practical Example',
              content: concept.practicalExample),
          _Section(
              title: 'Common Failure Mode', content: concept.failureMode),
          _Section(
              title: 'Interview Answer',
              content: concept.interviewAnswer),

          // Related concepts
          if (concept.relatedConceptIds.isNotEmpty) ...[
            const Text(
              'RELATED CONCEPTS',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: concept.relatedConceptIds.map((id) {
                return ActionChip(
                  label: Text(id.replaceAll('_', ' ')),
                  onPressed: () => context.push('/concept/$id'),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Review stats
          if (card != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR STATS',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StatLine('Ease Factor', card.easeFactor.toStringAsFixed(2)),
                  _StatLine('Interval', '${card.interval} days'),
                  _StatLine('Repetitions', '${card.repetitions}'),
                  _StatLine(
                    'Next Review',
                    _formatDate(card.nextReviewDate),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    if (diff <= 0) return 'Due now';
    if (diff == 1) return 'Tomorrow';
    return 'In $diff days';
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  final String label;
  final String value;

  const _StatLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }
}
