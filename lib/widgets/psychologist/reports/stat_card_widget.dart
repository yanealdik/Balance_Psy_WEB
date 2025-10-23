import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет карточки статистики
class StatCardWidget extends StatelessWidget {
  final String number;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const StatCardWidget({
    super.key,
    required this.number,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: (backgroundColor ?? AppColors.primary).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? AppColors.primary).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppTextStyles.h1.copyWith(
              fontSize: 48,
              color: textColor ?? AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              fontSize: 14,
              color: textColor ?? AppColors.textWhite,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
