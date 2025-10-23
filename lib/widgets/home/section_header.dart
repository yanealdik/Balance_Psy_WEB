import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String actionText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.actionText = 'Все',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3.copyWith(fontSize: 22)),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 15,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
