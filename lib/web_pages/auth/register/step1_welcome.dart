import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Добро пожаловать в',
            style: AppTextStyles.h2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Balance', style: AppTextStyles.h1.copyWith(fontSize: 48)),
              Text(
                'Psy',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Платформа для вашего психологического баланса и саморазвития',
            style: AppTextStyles.body1.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 280,
            height: 56,
            child: CustomButton(
              text: 'Начать регистрацию',
              onPressed: onNext,
              isPrimary: true,
              showArrow: true,
              isFullWidth: true,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/web/login');
            },
            child: Text(
              'Уже есть аккаунт? Войти',
              style: AppTextStyles.body1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
