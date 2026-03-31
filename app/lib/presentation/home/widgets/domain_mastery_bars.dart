import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/domain_tag.dart';
import '../../../domain/entities/user_progress.dart';

/// Horizontal mastery bars for each domain.
class DomainMasteryBars extends StatelessWidget {
  final List<DomainMastery> domains;

  const DomainMasteryBars({super.key, required this.domains});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: domains.map((d) => _DomainBar(mastery: d)).toList(),
    );
  }
}

class _DomainBar extends StatelessWidget {
  final DomainMastery mastery;

  const _DomainBar({required this.mastery});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.domainColor(mastery.domain);
    final label = _domainLabel(mastery.domain);
    final pct = (mastery.masteryScore * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: mastery.masteryScore.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.borderDark,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 36,
            child: Text(
              '$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _domainLabel(String domain) {
    try {
      return DomainTag.fromString(domain).label;
    } catch (_) {
      return domain;
    }
  }
}
