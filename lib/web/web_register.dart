import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

/// Главный контейнер для процесса регистрации
class WebRegisterFlow extends StatefulWidget {
  const WebRegisterFlow({super.key});

  @override
  State<WebRegisterFlow> createState() => _WebRegisterFlowState();
}

class _WebRegisterFlowState extends State<WebRegisterFlow> {
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
    Navigator.pushReplacementNamed(context, '/web/dashboard');
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

// ============= ШАГ 1: ПРИВЕТСТВИЕ =============
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

// ============= ШАГ 2: ВЫБОР ЦЕЛИ =============
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

// ============= ШАГ 3: О СЕБЕ =============
class AboutStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AboutStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AboutStep> createState() => _AboutStepState();
}

class _AboutStepState extends State<AboutStep> {
  final _nameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data['name'] ?? '';
    _selectedGender = widget.data['gender'];
    _selectedDate = widget.data['birthDate'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.isNotEmpty &&
      _selectedGender != null &&
      _selectedDate != null;

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.data['birthDate'] = picked;

        // Проверка возраста
        final age = DateTime.now().difference(picked).inDays ~/ 365;
        widget.data['isMinor'] = age < 18;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Расскажите о себе', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Это поможет нам подобрать подходящего специалиста',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ваше имя', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      hintText: 'Введите имя',
                      hintStyle: AppTextStyles.inputHint,
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.data['name'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Пол', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildGenderButton('Мужской', 'male')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGenderButton('Женский', 'female')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Дата рождения', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                                : 'Выберите дату',
                            style: _selectedDate != null
                                ? AppTextStyles.input
                                : AppTextStyles.inputHint,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.data['isMinor'] == true) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Вам меньше 18 лет. Потребуется согласие родителя',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 56,
            child: CustomButton(
              text: 'Продолжить',
              onPressed: _canContinue ? widget.onNext : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
          widget.data['gender'] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ============= ШАГ 4: АККАУНТ =============
class AccountStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AccountStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AccountStep> createState() => _AccountStepState();
}

class _AccountStepState extends State<AccountStep> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _codeSent = false;
  bool _codeVerified = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.data['email'] ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() {
    // TODO: Отправка кода на email
    setState(() {
      _codeSent = true;
    });
  }

  void _verifyCode() {
    // TODO: Проверка кода
    if (_codeController.text.length == 6) {
      setState(() {
        _codeVerified = true;
        widget.data['email'] = _emailController.text;
      });
    }
  }

  bool get _canContinue =>
      _codeVerified &&
      _passwordController.text.length >= 6 &&
      _passwordController.text == _confirmPasswordController.text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Создайте аккаунт', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Укажите email и придумайте надежный пароль',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          enabled: !_codeVerified,
                          style: AppTextStyles.input,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'example@email.com',
                            hintStyle: AppTextStyles.inputHint,
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            suffixIcon: _codeVerified
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.inputBorder,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.success.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_codeVerified) ...[
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          height: 56,
                          child: CustomButton(
                            text: _codeSent
                                ? 'Отправить снова'
                                : 'Отправить код',
                            onPressed: _emailController.text.contains('@')
                                ? _sendCode
                                : null,
                            isPrimary: false,
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_codeSent && !_codeVerified) ...[
                    const SizedBox(height: 24),
                    Text('Код подтверждения', style: AppTextStyles.body1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            style: AppTextStyles.input,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              hintText: '000000',
                              hintStyle: AppTextStyles.inputHint,
                              filled: true,
                              fillColor: AppColors.inputBackground,
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.inputBorder,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.inputBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 6) {
                                _verifyCode();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 140,
                          height: 56,
                          child: CustomButton(
                            text: 'Проверить',
                            onPressed: _codeController.text.length == 6
                                ? _verifyCode
                                : null,
                            isPrimary: true,
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_codeVerified) ...[
                    const SizedBox(height: 24),
                    Text('Пароль', style: AppTextStyles.body1),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      style: AppTextStyles.input,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Минимум 6 символов',
                        hintStyle: AppTextStyles.inputHint,
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                    Text('Подтвердите пароль', style: AppTextStyles.body1),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      style: AppTextStyles.input,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: 'Повторите пароль',
                        hintStyle: AppTextStyles.inputHint,
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    if (_confirmPasswordController.text.isNotEmpty &&
                        _passwordController.text !=
                            _confirmPasswordController.text) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Пароли не совпадают',
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 56,
            child: CustomButton(
              text: 'Продолжить',
              onPressed: _canContinue ? widget.onNext : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ============= ШАГ 5: ИНТЕРЕСЫ =============
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

// ============= ШАГ 6: ТУТОРИАЛ =============
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

// ============= ШАГ 7: ЗАВЕРШЕНИЕ =============
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
