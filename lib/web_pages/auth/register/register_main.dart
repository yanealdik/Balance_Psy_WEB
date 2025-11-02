import 'package:balance_psy/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../models/user_register_model.dart';
import 'step1_user_info.dart';
import 'step2_email.dart';
import 'step3_birthdate.dart';
import 'step4_verification.dart';
import 'step5_password.dart';
import 'step6_finish.dart';

/// Главный контейнер для веб-регистрации с навигацией по шагам
class RegisterMain extends StatefulWidget {
  const RegisterMain({super.key});

  @override
  State<RegisterMain> createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  late AnimationController _animController;

  // Модель данных для регистрации
  final UserRegisterModel _userData = UserRegisterModel();

  final List<StepInfo> _steps = [
    StepInfo(
      title: 'Информация о вас',
      subtitle: 'Имя и цели',
      icon: Icons.person_outline,
    ),
    StepInfo(
      title: 'Email адрес',
      subtitle: 'Контактные данные',
      icon: Icons.email_outlined,
    ),
    StepInfo(
      title: 'Дата рождения',
      subtitle: 'Ваш возраст',
      icon: Icons.cake_outlined,
    ),
    StepInfo(
      title: 'Подтверждение',
      subtitle: 'Код из письма',
      icon: Icons.verified_outlined,
    ),
    StepInfo(
      title: 'Пароль',
      subtitle: 'Защита аккаунта',
      icon: Icons.lock_outline,
    ),
    StepInfo(
      title: 'Завершение',
      subtitle: 'Готово!',
      icon: Icons.check_circle_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _animController.forward(from: 0);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _completeRegistration() async {
    try {
      await ApiService.register(
        email: _userData.email!,
        password: _userData.password!,
        passwordRepeat: _userData.password!,
        fullName: _userData.name!,
        dateOfBirth: _userData.birthDate!.toIso8601String().split('T')[0],
        gender: _userData.gender!,
        interests: _userData.interests,
        registrationGoal: _userData.purposes.join(', '),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка регистрации: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width < 1024 && size.width >= 768;
    final isMobile = size.width < 768;

    if (isMobile) {
      return _buildMobileLayout();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          // Левая панель с навигацией по шагам
          _buildStepsNavigator(isTablet),

          // Правая часть с формами
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Step1UserInfo(userData: _userData, onNext: _nextStep),
                        Step2Email(
                          userData: _userData,
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        Step3Birthdate(
                          userData: _userData,
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        Step4Verification(
                          userData: _userData,
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        Step5Password(
                          userData: _userData,
                          onNext: _nextStep,
                          onBack: _previousStep,
                        ),
                        Step6Finish(onComplete: _completeRegistration),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileProgress(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1UserInfo(userData: _userData, onNext: _nextStep),
                  Step2Email(
                    userData: _userData,
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  Step3Birthdate(
                    userData: _userData,
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  Step4Verification(
                    userData: _userData,
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  Step5Password(
                    userData: _userData,
                    onNext: _nextStep,
                    onBack: _previousStep,
                  ),
                  Step6Finish(onComplete: _completeRegistration),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsNavigator(bool isTablet) {
    return Container(
      width: isTablet ? 300 : 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.04),
            AppColors.primaryLight.withOpacity(0.08),
            Colors.white,
          ],
        ),
        border: Border(
          right: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isTablet ? 28 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Balance',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: isTablet ? 24 : 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Psy',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: isTablet ? 24 : 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Регистрация',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 28,
                horizontal: isTablet ? 20 : 28,
              ),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                return _buildStepItem(_steps[index], index, isTablet);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isTablet ? 28 : 40),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Нужна помощь?',
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(StepInfo step, int index, bool isTablet) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: index <= _currentStep
              ? () {
                  setState(() => _currentStep = index);
                  _pageController.jumpToPage(index);
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 14 : 16),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : isCompleted
                  ? AppColors.success.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? AppColors.primary
                    : isCompleted
                    ? AppColors.success.withOpacity(0.3)
                    : Colors.transparent,
                width: isActive ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: isTablet ? 44 : 48,
                  height: isTablet ? 44 : 48,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                        ? AppColors.success
                        : AppColors.inputBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 22)
                        : Icon(
                            step.icon,
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isActive || isCompleted
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        step.subtitle,
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
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.inputBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textSecondary,
              ),
              onPressed: _previousStep,
              tooltip: 'Назад',
            ),
          const Spacer(),
          Text(
            'Шаг ${_currentStep + 1} из ${_steps.length}',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                minHeight: 8,
                backgroundColor: AppColors.inputBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.inputBorder.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentStep > 0)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousStep,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _steps[_currentStep].title,
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                  textAlign: _currentStep > 0
                      ? TextAlign.start
                      : TextAlign.center,
                ),
              ),
              if (_currentStep == 0) const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
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
}

class StepInfo {
  final String title;
  final String subtitle;
  final IconData icon;

  StepInfo({required this.title, required this.subtitle, required this.icon});
}
