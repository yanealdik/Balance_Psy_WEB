import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../models/user_register_model.dart';

class Step5Password extends StatefulWidget {
  final UserRegisterModel userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Password({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5Password> createState() => _Step5PasswordState();
}

class _Step5PasswordState extends State<Step5Password> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Требования к паролю
  bool _hasMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordRequirements);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkPasswordRequirements);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordRequirements() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool get _isPasswordStrong =>
      _hasMinLength && _hasUpperCase && _hasLowerCase && _hasDigit;

  bool get _canContinue =>
      _isPasswordStrong &&
      _passwordController.text == _confirmPasswordController.text;

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.userData.password = _passwordController.text;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 24 : 60),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildPasswordField(isMobile),
                SizedBox(height: isMobile ? 20 : 24),
                _buildPasswordRequirements(isMobile),
                SizedBox(height: isMobile ? 24 : 32),
                _buildConfirmPasswordField(isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildButtons(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Создайте пароль',
          style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
        ),
        const SizedBox(height: 8),
        Text(
          'Придумайте надежный пароль для защиты вашего аккаунта',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPasswordField(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пароль',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          style: AppTextStyles.input,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Введите пароль',
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.inputBackground,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите пароль';
            }
            if (!_isPasswordStrong) {
              return 'Пароль не соответствует требованиям';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Требования к паролю:',
            style: AppTextStyles.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirementItem('Минимум 8 символов', _hasMinLength),
          const SizedBox(height: 8),
          _buildRequirementItem('Заглавная буква (A-Z)', _hasUpperCase),
          const SizedBox(height: 8),
          _buildRequirementItem('Строчная буква (a-z)', _hasLowerCase),
          const SizedBox(height: 8),
          _buildRequirementItem('Цифра (0-9)', _hasDigit),
          const SizedBox(height: 8),
          _buildRequirementItem(
            'Специальный символ (!@#\$%^&*)',
            _hasSpecialChar,
            optional: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(
    String text,
    bool satisfied, {
    bool optional = false,
  }) {
    return Row(
      children: [
        Icon(
          satisfied ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 18,
          color: satisfied ? AppColors.success : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text + (optional ? ' (рекомендуется)' : ''),
            style: AppTextStyles.body3.copyWith(
              color: satisfied ? AppColors.success : AppColors.textSecondary,
              decoration: satisfied ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Подтвердите пароль',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          style: AppTextStyles.input,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Повторите пароль',
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.inputBackground,
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
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
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
          onChanged: (value) => setState(() {}),
        ),
        if (_confirmPasswordController.text.isNotEmpty &&
            _passwordController.text != _confirmPasswordController.text) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
              const SizedBox(width: 4),
              Text(
                'Пароли не совпадают',
                style: AppTextStyles.body3.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildButtons(bool isMobile) {
    return Row(
      children: [
        if (!isMobile) ...[
          SizedBox(
            width: 140,
            height: 56,
            child: CustomButton(
              text: 'Назад',
              onPressed: widget.onBack,
              isPrimary: false,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
        ],
        SizedBox(
          width: isMobile ? double.infinity : 260,
          height: 56,
          child: CustomButton(
            text: 'Завершить регистрацию',
            onPressed: _canContinue ? _handleNext : null,
            isPrimary: true,
            isFullWidth: true,
            showArrow: true,
          ),
        ),
      ],
    );
  }
}
