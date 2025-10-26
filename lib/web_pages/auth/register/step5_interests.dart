import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class InterestsStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const InterestsStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  final List<String> _interests = [
    'Управление стрессом',
    'Семейные отношения',
    'Карьера',
    'Самооценка',
    'Депрессия',
    'Тревожность',
    'Личностный рост',
    'Общение',
    'Потеря близких',
    'Зависимости',
    'Родительство',
    'Сексуальность',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedInterests = widget.data['interests'] as List<String>;

    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Выберите интересующие темы', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Мы подберем специалистов и материалы под ваши запросы',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _interests.map((interest) {
                  final isSelected = selectedInterests.contains(interest);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedInterests.remove(interest);
                        } else {
                          selectedInterests.add(interest);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.inputBorder,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        interest,
                        style: AppTextStyles.body1.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 56,
            child: CustomButton(
              text: 'Продолжить',
              onPressed: selectedInterests.isNotEmpty ? widget.onNext : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
