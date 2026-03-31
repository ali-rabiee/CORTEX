import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Rating bar for self-assessed confidence (1-5).
class ConfidenceRatingBar extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onSelect;

  const ConfidenceRatingBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _labels = ['Guess', 'Weak', 'Ok', 'Good', 'Certain'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (i) {
        final value = i + 1;
        final isSelected = selected == value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 4 ? 6 : 0),
            child: InkWell(
              onTap: () => onSelect(value),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.info.withValues(alpha: 0.2)
                      : AppColors.cardDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.info : AppColors.borderDark,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.info
                        : AppColors.textSecondary,
                    fontSize: 11,
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
