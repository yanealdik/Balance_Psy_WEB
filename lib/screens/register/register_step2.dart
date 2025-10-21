import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/step_indicator.dart';
import '../../widgets/back_button.dart';
import '../register/register_step3.dart';

/// Экран онбординга Шаг 2 - Имя и интересы
class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  final TextEditingController _nameController = TextEditingController();
  List<int> selectedInterests = [];

  final List<Map<String, dynamic>> interests = [
    {
      'icon': Icons.self_improvement,
      'text': 'Медитация',
      'color': const Color(0xFF6366F1),
    },
    {
      'icon': Icons.psychology_outlined,
      'text': 'Психология',
      'color': const Color(0xFFEC4899),
    },
    {'icon': Icons.spa, 'text': 'Йога', 'color': const Color(0xFF8B5CF6)},
    {
      'icon': Icons.favorite_outline,
      'text': 'Отношения',
      'color': const Color(0xFFF43F5E),
    },
    {
      'icon': Icons.work_outline,
      'text': 'Карьера',
      'color': const Color(0xFF3B82F6),
    },
    {
      'icon': Icons.family_restroom,
      'text': 'Семья',
      'color': const Color(0xFF10B981),
    },
    {
      'icon': Icons.fitness_center,
      'text': 'Здоровье',
      'color': const Color(0xFFF59E0B),
    },
    {
      'icon': Icons.emoji_emotions_outlined,
      'text': 'Эмоции',
      'color': const Color(0xFFEF4444),
    },
    {
      'icon': Icons.wb_sunny_outlined,
      'text': 'Энергия',
      'color': const Color(0xFFFBBF24),
    },
    {
      'icon': Icons.nights_stay_outlined,
      'text': 'Сон',
      'color': const Color(0xFF6366F1),
    },
    {
      'icon': Icons.school_outlined,
      'text': 'Обучение',
      'color': const Color(0xFF14B8A6),
    },
    {
      'icon': Icons.auto_awesome,
      'text': 'Саморазвитие',
      'color': const Color(0xFFA855F7),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Слушаем изменения в текстовом поле
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleInterest(int index) {
    setState(() {
      if (selectedInterests.contains(index)) {
        selectedInterests.remove(index);
      } else {
        selectedInterests.add(index);
      }
    });
  }

  bool get _canContinue {
    final name = _nameController.text.trim();
    // Проверяем что имя содержит хотя бы одну букву (любой язык) и не пустое
    final hasLetters = RegExp(r'[a-zA-Zа-яА-ЯёЁ]').hasMatch(name);
    return name.isNotEmpty &&
        name.length >= 2 &&
        hasLetters &&
        selectedInterests.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с кнопкой назад и индикатором
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  StepIndicator(currentStep: 2, totalSteps: 5),
                ],
              ),
            ),

            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Заголовок
                    Text(
                      'Расскажи о себе',
                      style: AppTextStyles.h2.copyWith(fontSize: 26),
                    ),

                    const SizedBox(height: 32),

                    // Поле ввода имени
                    Text(
                      'Как тебя зовут?',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Введи свое имя',
                      prefixIcon: Icons.person_outline,
                      enabled: true,
                      maxLength: 50,
                      onChanged: (value) {
                        setState(() {}); // Важно: добавьте setState здесь!
                      },
                    ),

                    // Подсказка для имени
                    if (_nameController.text.isNotEmpty &&
                        _nameController.text.trim().length < 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          'Имя должно содержать минимум 2 символа',
                          style: AppTextStyles.body3.copyWith(
                            color: Colors.orange,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Выбор интересов
                    Text(
                      'Что тебя интересует?',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Выбери несколько тем',
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Сетка интересов
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        interests.length,
                        (index) => _buildInterestChip(index),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Индикатор выбора
                    if (selectedInterests.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${selectedInterests.length}',
                                style: AppTextStyles.body3.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _getInterestCountText(),
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Кнопка "Продолжить"
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: 'Продолжить',
                showArrow: true,
                onPressed: _canContinue
                    ? () {
                        // Сохраняем имя и интересы
                        print('Name: ${_nameController.text}');
                        print('Interests: $selectedInterests');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingStep3Screen(),
                          ),
                        );
                      }
                    : null, isFullWidth: true,
              ),
            ),

            // DEBUG: Показываем состояние (удалить после тестирования)
            if (true) // Измените на false когда проверите
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Debug: Name="${_nameController.text.trim()}" (${_nameController.text.trim().length} chars), Interests=${selectedInterests.length}, CanContinue=$_canContinue',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getInterestCountText() {
    final count = selectedInterests.length;
    if (count == 1) return 'Выбрана 1 тема';
    if (count >= 2 && count <= 4) return 'Выбрано $count темы';
    return 'Выбрано $count тем';
  }

  // Чип интереса
  Widget _buildInterestChip(int index) {
    final interest = interests[index];
    final isSelected = selectedInterests.contains(index);

    return GestureDetector(
      onTap: () => _toggleInterest(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? interest['color'].withOpacity(0.15)
              : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? interest['color'].withOpacity(0.5)
                : AppColors.inputBorder,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: interest['color'].withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              interest['icon'],
              size: 20,
              color: isSelected ? interest['color'] : AppColors.textSecondary,
            ),
            const SizedBox(width: 7),
            Text(
              interest['text'],
              style: AppTextStyles.body2.copyWith(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? interest['color'] : AppColors.textPrimary,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 5),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: interest['color'],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 11, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
