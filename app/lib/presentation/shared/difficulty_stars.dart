import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Displays difficulty as filled/unfilled stars (1-5).
class DifficultyStars extends StatelessWidget {
  final int level;
  final int maxLevel;
  final double size;

  const DifficultyStars({
    super.key,
    required this.level,
    this.maxLevel = 5,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLevel, (i) {
        return Icon(
          i < level ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < level ? AppColors.warning : AppColors.textMuted,
        );
      }),
    );
  }
}
