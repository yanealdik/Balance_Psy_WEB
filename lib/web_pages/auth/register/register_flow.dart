import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../сore/router/app_router.dart';
import 'step1_welcome.dart';
import 'step2_purpose.dart';
import 'step3_about.dart';
import 'step4_account.dart';
import 'step5_interests.dart';
import 'step6_tutorial.dart';
import 'step7_finish.dart';

/// Главный контейнер для процесса регистрации
class RegisterFlow extends StatefulWidget {
  const RegisterFlow({super.key});

  @override
  State<RegisterFlow> createState() => _RegisterFlowState();
}

class _RegisterFlowState extends State<RegisterFlow> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Данные регистрации
  final Map<String, dynamic> _registrationData = {
    'purposes': <String>[],
    'name': '',
    'gender': '',
    'birthDate': null,
    'isMinor': false,
    'parentEmail': '',
    'email': '',
    'verificationCode': '',
    'password': '',
    'interests': <String>[],
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeRegistration() {
    // TODO: Отправка данных на сервер
    Navigator.pushReplacementNamed(context, AppRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (isMobile) {
      return _buildMobileLayout();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          // Левая часть - форма
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      WelcomeStep(onNext: _nextStep),
                      PurposeStep(
                        data: _registrationData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      AboutStep(
                        data: _registrationData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      AccountStep(
                        data: _registrationData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      InterestsStep(
                        data: _registrationData,
                        onNext: _nextStep,
                        onBack: _previousStep,
                      ),
                      TutorialStep(
                        onNext: _completeRegistration,
                        onSkip: _completeRegistration,
                      ),
                      FinishStep(onComplete: _completeRegistration),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Правая часть - иллюстрация
          Expanded(flex: 4, child: _buildIllustrationSide()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                WelcomeStep(onNext: _nextStep),
                PurposeStep(
                  data: _registrationData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                AboutStep(
                  data: _registrationData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                AccountStep(
                  data: _registrationData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                InterestsStep(
                  data: _registrationData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                TutorialStep(
                  onNext: _completeRegistration,
                  onSkip: _completeRegistration,
                ),
                FinishStep(onComplete: _completeRegistration),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textSecondary,
                ),
                onPressed: _currentStep > 0 ? _previousStep : null,
              ),
              const Spacer(),
              Text(
                'Шаг ${_currentStep + 1} из $_totalSteps',
                style: AppTextStyles.body2,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 6,
              backgroundColor: AppColors.inputBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationSide() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLight.withOpacity(0.3),
            AppColors.backgroundLight,
            AppColors.inputBackground,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIllustrationIcon(),
                size: 150,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getIllustrationText(),
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIllustrationIcon() {
    switch (_currentStep) {
      case 0:
        return Icons.wb_sunny_outlined;
      case 1:
        return Icons.favorite_border;
      case 2:
        return Icons.person_outline;
      case 3:
        return Icons.email_outlined;
      case 4:
        return Icons.interests_outlined;
      case 5:
        return Icons.school_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _getIllustrationText() {
    switch (_currentStep) {
      case 0:
        return 'Добро пожаловать в BalancePsy';
      case 1:
        return 'Расскажите, что привело вас к нам';
      case 2:
        return 'Познакомимся поближе';
      case 3:
        return 'Создайте свой аккаунт';
      case 4:
        return 'Выберите интересующие темы';
      case 5:
        return 'Пройдите краткое обучение';
      default:
        return 'Добро пожаловать!';
    }
  }
}
