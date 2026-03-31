import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Rating bar for recall quality (0-5).
class QualityRatingBar extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onSelect;

  const QualityRatingBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        final isSelected = selected == i;
        final color = AppColors.qualityColor(i);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 5 ? 6 : 0),
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? color : AppColors.borderDark,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$i',
                  style: TextStyle(
                    color: isSelected ? color : AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
