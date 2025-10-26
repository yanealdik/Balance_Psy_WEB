import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class FinishStep extends StatelessWidget {
  final VoidCallback onComplete;

  const FinishStep({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Регистрация завершена!',
            style: AppTextStyles.h1.copyWith(fontSize: 36),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Добро пожаловать в BalancePsy. Теперь вы можете начать работу с платформой',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 280,
            height: 56,
            child: CustomButton(
              text: 'Перейти в личный кабинет',
              onPressed: onComplete,
              isPrimary: true,
              showArrow: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
