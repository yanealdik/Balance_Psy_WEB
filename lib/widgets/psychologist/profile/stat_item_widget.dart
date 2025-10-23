import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет элемента статистики (для профиля психолога)
class StatItemWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatItemWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.h3.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text(title, style: AppTextStyles.body2.copyWith(fontSize: 12)),
      ],
    );
  }
}
