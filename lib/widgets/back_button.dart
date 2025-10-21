import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Кастомная кнопка "Назад"
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}
