// lib/web_pages/auth/forgot_password_page.dart

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../services/user_service.dart';
import '../../../widgets/WEB/web_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _codeSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await UserService.requestPasswordReset(_emailController.text);
      setState(() {
        _codeSent = true;
        _isLoading = false;
      });
      _showSnackBar('Код отправлен на ваш email');
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Ошибка: $e', isError: true);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await UserService.resetPassword(
        email: _emailController.text,
        code: _codeController.text,
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      setState(() => _isLoading = false);

      if (mounted) {
        _showSnackBar('Пароль успешно изменён!');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Ошибка: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  if (!_codeSent) ...[
                    _buildEmailField(),
                    const SizedBox(height: 32),
                    _buildSendCodeButton(),
                  ] else ...[
                    _buildCodeField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 20),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 32),
                    _buildResetButton(),
                  ],
                  const SizedBox(height: 20),
                  _buildBackToLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Text('Balance', style: AppTextStyles.logo.copyWith(fontSize: 28)),
            Text(
              'Psy',
              style: AppTextStyles.logo.copyWith(
                fontSize: 28,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          _codeSent ? 'Создайте новый пароль' : 'Восстановление пароля',
          style: AppTextStyles.h1,
        ),
        const SizedBox(height: 12),
        Text(
          _codeSent
              ? 'Введите код из email и новый пароль'
              : 'Мы отправим код восстановления на ваш email',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          style: AppTextStyles.input,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'example@email.com',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Неверный формат email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Код из письма', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextFormField(
          controller: _codeController,
          style: AppTextStyles.input,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: '123456',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(Icons.key, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.inputBackground,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите код';
            }
            if (value.length != 6) {
              return 'Код должен содержать 6 цифр';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Новый пароль', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          style: AppTextStyles.input,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Минимум 6 символов',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите пароль';
            }
            if (value.length < 6) {
              return 'Минимум 6 символов';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Подтвердите пароль', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          style: AppTextStyles.input,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Повторите пароль',
            hintStyle: AppTextStyles.inputHint,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Подтвердите пароль';
            }
            if (value != _passwordController.text) {
              return 'Пароли не совпадают';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSendCodeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: WebButton(
        text: _isLoading ? 'Отправка...' : 'Отправить код',
        onPressed: _isLoading ? null : _sendCode,
        isPrimary: true,
        isFullWidth: true,
        showArrow: !_isLoading,
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: WebButton(
        text: _isLoading ? 'Сброс...' : 'Сбросить пароль',
        onPressed: _isLoading ? null : _resetPassword,
        isPrimary: true,
        isFullWidth: true,
        showArrow: !_isLoading,
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        child: Text(
          'Вернуться к входу',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
