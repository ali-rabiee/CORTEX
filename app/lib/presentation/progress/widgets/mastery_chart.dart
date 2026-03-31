import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/domain_tag.dart';
import '../../../domain/entities/user_progress.dart';

/// Vertical bar chart showing per-domain mastery.
class MasteryChart extends StatelessWidget {
  final List<DomainMastery> domains;

  const MasteryChart({super.key, required this.domains});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: domains.map((d) {
          final color = AppColors.domainColor(d.domain);
          final pct = (d.masteryScore * 100).round();
          String label;
          try {
            label = DomainTag.fromString(d.domain).shortLabel;
          } catch (_) {
            label = d.domain;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$pct%',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: d.masteryScore.clamp(0.05, 1.0),
                    child: Container(
                      width: 32,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
