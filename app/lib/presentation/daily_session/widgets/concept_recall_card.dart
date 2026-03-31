import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/concept.dart';
import '../../shared/domain_tag_chip.dart';
import '../../shared/difficulty_stars.dart';

/// Card that shows concept title (face) and full details (revealed).
class ConceptRecallCard extends StatelessWidget {
  final Concept concept;
  final bool revealed;
  final VoidCallback onReveal;

  const ConceptRecallCard({
    super.key,
    required this.concept,
    required this.revealed,
    required this.onReveal,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Wrap(
            spacing: 6,
            children: concept.tags
                .map((t) => DomainTagChip(tag: t))
                .toList(),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            concept.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Difficulty
          Row(
            children: [
              const Text(
                'Difficulty: ',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              DifficultyStars(level: concept.difficulty),
            ],
          ),

          if (!revealed) ...[
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Can you explain this concept?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onReveal,
                child: const Text('Reveal Answer'),
              ),
            ),
          ],

          if (revealed) ...[
            const SizedBox(height: 16),
            _Section(title: 'Definition', content: concept.definition),
            _Section(title: 'Intuition', content: concept.intuition),
            _Section(
              title: 'Practical Example',
              content: concept.practicalExample,
            ),
            _Section(title: 'Common Failure Mode', content: concept.failureMode),
            _Section(
              title: 'Interview Answer',
              content: concept.interviewAnswer,
            ),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
