import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/WEB/web_button.dart';
import '../../../models/user_register_model.dart';

class Step2Email extends StatefulWidget {
  final UserRegisterModel userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Email({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2Email> createState() => _Step2EmailState();
}

class _Step2EmailState extends State<Step2Email> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.userData.email ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _checkEmailAvailability() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isChecking = true);

    // TODO: Проверка email на бэкенде
    // GET /api/auth/check-email?email=${_emailController.text}
    // Response: { "available": true/false }

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isChecking = false);

    widget.userData.email = _emailController.text;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 32 : 48,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 900,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 40 : 56),
                _buildEmailField(isMobile),
                const SizedBox(height: 24),
                _buildInfoCard(isMobile),
                SizedBox(height: isMobile ? 40 : 56),
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
          'Email адрес',
          style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
        ),
        const SizedBox(height: 12),
        Text(
          'Укажите email для входа и получения уведомлений',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          style: AppTextStyles.input,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'example@email.com',
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.inputBackground,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primary,
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
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите email';
            }
            if (!_isValidEmail(value)) {
              return 'Введите корректный email адрес';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Зачем нужен email?',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Мы отправим код подтверждения на этот адрес. Также вы будете получать уведомления о консультациях и новых материалах.',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(bool isMobile) {
    final canContinue =
        _emailController.text.isNotEmpty &&
        _isValidEmail(_emailController.text);

    return Row(
      children: [
        if (!isMobile) ...[
          SizedBox(
            width: 140,
            height: 56,
            child: WebButton(
              text: 'Назад',
              onPressed: widget.onBack,
              isPrimary: false,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: SizedBox(
            height: 56,
            child: WebButton(
              text: _isChecking ? 'Проверка...' : 'Продолжить',
              onPressed: _isChecking
                  ? null
                  : (canContinue ? _checkEmailAvailability : null),
              isPrimary: true,
              isFullWidth: true,
              showArrow: !_isChecking,
            ),
          ),
        ),
      ],
    );
  }
}
