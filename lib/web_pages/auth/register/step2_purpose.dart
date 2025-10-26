import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class PurposeStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PurposeStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PurposeStep> createState() => _PurposeStepState();
}

class _PurposeStepState extends State<PurposeStep> {
  final List<String> _purposes = [
    'Справиться с тревогой',
    'Улучшить отношения',
    'Разобраться в себе',
    'Пережить кризис',
    'Повысить самооценку',
    'Найти смысл жизни',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPurposes = widget.data['purposes'] as List<String>;

    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Что привело вас к нам?', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Выберите одну или несколько целей',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                childAspectRatio: 2.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _purposes.length,
              itemBuilder: (context, index) {
                final purpose = _purposes[index];
                final isSelected = selectedPurposes.contains(purpose);

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedPurposes.remove(purpose);
                      } else {
                        selectedPurposes.add(purpose);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inputBorder,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            purpose,
                            style: AppTextStyles.body1.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 56,
            child: CustomButton(
              text: 'Продолжить',
              onPressed: selectedPurposes.isNotEmpty ? widget.onNext : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
