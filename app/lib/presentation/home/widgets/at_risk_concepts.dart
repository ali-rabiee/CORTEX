import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../shared/domain_tag_chip.dart';
import '../home_screen.dart';

/// Horizontal scrollable row of at-risk concept chips.
class AtRiskConcepts extends StatelessWidget {
  final List<AtRiskConcept> concepts;

  const AtRiskConcepts({super.key, required this.concepts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: concepts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final c = concepts[index];
          return InkWell(
            onTap: () => context.push('/concept/${c.conceptId}'),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.title.length > 25
                        ? '${c.title.substring(0, 25)}...'
                        : c.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: c.tags
                        .take(2)
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: DomainTagChip(tag: t),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
