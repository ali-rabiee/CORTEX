import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/domain_tag.dart';

/// Compact chip showing a domain tag with its associated color.
class DomainTagChip extends StatelessWidget {
  final String tag;

  const DomainTagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.domainColor(tag);
    final label = _labelForTag(tag);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _labelForTag(String tag) {
    try {
      return DomainTag.fromString(tag).shortLabel;
    } catch (_) {
      return tag;
    }
  }
}
