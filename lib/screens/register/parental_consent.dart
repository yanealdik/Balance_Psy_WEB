import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/back_button.dart';
import '../register/register_step5.dart';

/// Экран согласия родителей для пользователей младше 18 лет
class ParentalConsentScreen extends StatefulWidget {
  final int age;

  const ParentalConsentScreen({
    super.key,
    required this.age,
  });

  @override
  State<ParentalConsentScreen> createState() => _ParentalConsentScreenState();
}

class _ParentalConsentScreenState extends State<ParentalConsentScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isAgreed = false;
  String? errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _sendParentalConsent() {
    setState(() {
      errorMessage = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        errorMessage = 'Пожалуйста, введите email родителя';
      });
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        errorMessage = 'Введите корректный email адрес';
      });
      return;
    }

    if (!_isAgreed) {
      setState(() {
        errorMessage = 'Необходимо согласие родителя';
      });
      return;
    }

    // Здесь должна быть логика отправки email родителю
    // Показываем диалог подтверждения
    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.email_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Письмо отправлено',
                style: AppTextStyles.h3,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Мы отправили письмо с запросом согласия на адрес:',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _emailController.text,
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'После подтверждения родителем вы сможете продолжить регистрацию.',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Для демонстрации переходим на следующий экран
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnboardingStep5Screen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с кнопкой назад
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CustomBackButton(),
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

                    // Иконка
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.family_restroom,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Заголовок
                    Text(
                      'Требуется согласие родителя',
                      style: AppTextStyles.h2.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Описание
                    Text(
                      'Вам ${widget.age} лет. Для продолжения регистрации необходимо разрешение вашего родителя или опекуна.',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Как это работает
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Как это работает:',
                            style: AppTextStyles.h1.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildStep(
                            '1',
                            'Введите email вашего родителя',
                          ),
                          const SizedBox(height: 12),
                          _buildStep(
                            '2',
                            'Мы отправим письмо с запросом согласия',
                          ),
                          const SizedBox(height: 12),
                          _buildStep(
                            '3',
                            'После подтверждения вы сможете продолжить',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email родителя
                    Text(
                      'Email родителя или опекуна',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.body1,
                      decoration: InputDecoration(
                        hintText: 'parent@example.com',
                        hintStyle: AppTextStyles.body1.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (errorMessage != null) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // Чекбокс согласия
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAgreed = !_isAgreed;
                          if (_isAgreed && errorMessage != null) {
                            errorMessage = null;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _isAgreed
                                ? AppColors.primary
                                : AppColors.inputBorder,
                            width: _isAgreed ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _isAgreed
                                    ? AppColors.primary
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _isAgreed
                                      ? AppColors.primary
                                      : AppColors.inputBorder,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _isAgreed
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text:
                                          'Я подтверждаю, что у меня есть разрешение родителя на предоставление этого email адреса и отправку запроса на согласие.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Сообщение об ошибке
                    if (errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: AppTextStyles.body2.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Дополнительная информация
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'Мы серьезно относимся к безопасности несовершеннолетних. ',
                                  ),
                                  TextSpan(
                                    text: 'Узнать больше',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Открыть страницу с информацией
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Кнопка "Отправить запрос"
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: 'Отправить запрос',
                showArrow: true,
                onPressed: _sendParentalConsent, isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}