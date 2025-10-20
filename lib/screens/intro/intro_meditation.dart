import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/back_button.dart';

/// Экран с медитацией
class IntroMeditationScreen extends StatefulWidget {
  const IntroMeditationScreen({Key? key}) : super(key: key);

  @override
  State<IntroMeditationScreen> createState() => _IntroMeditationScreenState();
}

class _IntroMeditationScreenState extends State<IntroMeditationScreen>
    with SingleTickerProviderStateMixin {
  bool _isStarted = false;
  bool _isCompleted = false;
  int _totalSeconds = 3; // 5 минут
  int _remainingSeconds = 300;
  Timer? _timer;
  late AnimationController _pulseController;

  final List<Map<String, String>> _steps = [
    {
      'time': '0:00',
      'title': 'Подготовка',
      'description':
          'Найди удобное место, где тебя никто не побеспокоит. Сядь или ляг в комфортную позу.',
    },
    {
      'time': '1:00',
      'title': 'Дыхание',
      'description':
          'Закрой глаза и сосредоточься на своем дыхании. Дыши естественно, не пытаясь контролировать.',
    },
    {
      'time': '2:00',
      'title': 'Осознанность',
      'description':
          'Почувствуй, как воздух входит и выходит из твоих легких. Наблюдай за этим процессом.',
    },
    {
      'time': '3:00',
      'title': 'Концентрация',
      'description':
          'Если мысли отвлекают - это нормально. Просто верни внимание к дыханию.',
    },
    {
      'time': '4:00',
      'title': 'Расслабление',
      'description':
          'Почувствуй, как твое тело расслабляется с каждым выдохом. Отпусти напряжение.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startMeditation() {
    setState(() {
      _isStarted = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isCompleted = true;
        }
      });
    });
  }

  void _pauseMeditation() {
    _timer?.cancel();
    setState(() {
      _isStarted = false;
    });
  }

  void _resetMeditation() {
    _timer?.cancel();
    setState(() {
      _isStarted = false;
      _isCompleted = false;
      _remainingSeconds = _totalSeconds;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  String _getCurrentStep() {
    final elapsed = _totalSeconds - _remainingSeconds;
    for (var i = _steps.length - 1; i >= 0; i--) {
      final stepTime = int.parse(_steps[i]['time']!.split(':')[0]) * 60;
      if (elapsed >= stepTime) {
        return _steps[i]['description']!;
      }
    }
    return _steps[0]['description']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с кнопкой назад
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CustomBackButton(
                    onPressed: () => Navigator.pop(context, _isCompleted),
                  ),
                ],
              ),
            ),

            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Заголовок
                    Text(
                      'Медитация осознанности',
                      style: AppTextStyles.h2.copyWith(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Практика для начинающих',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Анимированный круг с таймером
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.3),
                                AppColors.primary.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: [
                                0.0,
                                0.6 + (_pulseController.value * 0.2),
                                1.0,
                              ],
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius:
                                      20 + (_pulseController.value * 10),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatTime(_remainingSeconds),
                                    style: AppTextStyles.h1.copyWith(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'осталось',
                                    style: AppTextStyles.body3.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Текущий шаг медитации
                    if (_isStarted && !_isCompleted)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.self_improvement,
                              size: 40,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _getCurrentStep(),
                              style: AppTextStyles.body2.copyWith(
                                fontSize: 15,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    // Сообщение о завершении
                    if (_isCompleted)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Поздравляем!',
                              style: AppTextStyles.h3.copyWith(
                                color: Colors.green,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ты завершил свою первую медитацию! Регулярная практика поможет тебе достичь внутренней гармонии.',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                    // Инструкция перед началом
                    if (!_isStarted && !_isCompleted) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Инструкция:',
                              style: AppTextStyles.h3.copyWith(fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            ..._steps.map(
                              (step) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        step['time']!,
                                        style: AppTextStyles.body3.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step['title']!,
                                            style: AppTextStyles.body1.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            step['description']!,
                                            style: AppTextStyles.body3.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Кнопки управления
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (!_isCompleted) ...[
                    if (!_isStarted)
                      CustomButton(
                        text: 'Начать медитацию',
                        showArrow: true,
                        onPressed: _startMeditation,
                        isFullWidth: true,
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Пауза',
                              isPrimary: false,
                              onPressed: _pauseMeditation,
                              isFullWidth: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomButton(
                              text: 'Сброс',
                              isPrimary: false,
                              onPressed: _resetMeditation,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ] else
                    CustomButton(
                      text: 'Продолжить',
                      showArrow: true,
                      onPressed: () => Navigator.pop(context, true),
                      isFullWidth: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
