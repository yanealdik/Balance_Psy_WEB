import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

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
