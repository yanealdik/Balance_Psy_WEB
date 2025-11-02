// lib/widgets/home/custom_hero_button.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomHeroButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomHeroButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF57A2EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Выбрать психолога',
          style: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}