import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Кастомное текстовое поле
class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool showSuccess;
  final bool showEyeIcon;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool enabled;
  final int? maxLength;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.enabled,
    this.prefixIcon,
    this.isPassword = false,
    this.showSuccess = false,
    this.showEyeIcon = false,
    this.keyboardType,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: showSuccess ? AppColors.success : AppColors.inputBorder,
          width: 2,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: AppTextStyles.input,
        maxLength: maxLength,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          counterText: '', // Убираем счетчик символов
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(
                    prefixIcon,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                )
              : null,
          suffixIcon: showSuccess
              ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.check, color: AppColors.success, size: 24),
                )
              : showEyeIcon
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.visibility_off_outlined,
                    color: AppColors.textTertiary,
                    size: 24,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
