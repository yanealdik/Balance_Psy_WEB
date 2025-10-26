import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class TutorialStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TutorialStep({super.key, required this.onNext, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Готовы начать?', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Предлагаем пройти краткое обучение или сразу перейти к платформе',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
              children: [
                _buildTutorialCard(
                  'Видео-гайд',
                  'Краткое видео о возможностях платформы',
                  Icons.play_circle_outline,
                  AppColors.primary,
                ),
                _buildTutorialCard(
                  'Статья',
                  'Прочитайте о том, как работать с психологом',
                  Icons.article_outlined,
                  AppColors.primaryDark,
                ),
                _buildTutorialCard(
                  'Медитация',
                  'Короткая практика для знакомства',
                  Icons.self_improvement_outlined,
                  AppColors.primaryLight,
                ),
                _buildTutorialCard(
                  'FAQ',
                  'Ответы на частые вопросы',
                  Icons.help_outline,
                  AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 56,
                child: CustomButton(
                  text: 'Начать обучение',
                  onPressed: onNext,
                  isPrimary: true,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: onSkip,
                child: Text(
                  'Пропустить',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.h3.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
