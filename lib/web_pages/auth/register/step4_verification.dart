import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../models/user_register_model.dart';

class Step4Verification extends StatefulWidget {
  final UserRegisterModel userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Verification({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Verification> createState() => _Step4VerificationState();
}

class _Step4VerificationState extends State<Step4Verification> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _codeSent = false;
  bool _isVerifying = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    setState(() {
      _codeSent = true;
      _canResend = false;
      _resendTimer = 60;
    });

    // TODO: Отправка кода на email
    // POST /api/auth/send-verification-code
    // Body: { "email": widget.userData.email }

    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyCode() async {
    final code = _codeControllers.map((c) => c.text).join();

    if (code.length != 6) return;

    setState(() => _isVerifying = true);

    // TODO: Проверка кода на бэкенде
    // POST /api/auth/verify-code
    // Body: { "email": widget.userData.email, "code": code }
    // Response: { "valid": true/false }

    await Future.delayed(const Duration(seconds: 1)); // Симуляция запроса

    setState(() => _isVerifying = false);

    // Если код верный
    widget.userData.verificationCode = code;
    widget.onNext();
  }

  void _onCodeChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Автоматическая проверка при вводе последней цифры
    if (index == 5 && value.isNotEmpty) {
      _verifyCode();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 32 : 48),
              _buildCodeInput(isMobile),
              SizedBox(height: isMobile ? 24 : 32),
              _buildResendSection(isMobile),
              SizedBox(height: isMobile ? 24 : 32),
              _buildInfoCard(isMobile),
              SizedBox(height: isMobile ? 32 : 48),
              _buildButtons(isMobile),
            ],
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
          'Подтверждение email',
          style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'Мы отправили код на '),
              TextSpan(
                text: widget.userData.email,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Введите код из письма',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: isMobile ? 45 : 60,
              height: isMobile ? 55 : 70,
              child: TextField(
                controller: _codeControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyles.h2.copyWith(
                  fontSize: isMobile ? 24 : 32,
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
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
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onCodeChanged(index, value),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResendSection(bool isMobile) {
    return Center(
      child: Column(
        children: [
          if (!_canResend)
            Text(
              'Отправить код повторно через $_resendTimer сек',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            TextButton.icon(
              onPressed: _sendVerificationCode,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Отправить код повторно'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
        ],
      ),
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
          Icon(Icons.mail_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Не получили письмо?',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Проверьте папку "Спам" или дождитесь окончания таймера, чтобы отправить код повторно.',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
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
    final code = _codeControllers.map((c) => c.text).join();

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
          width: isMobile ? double.infinity : 220,
          height: 56,
          child: CustomButton(
            text: _isVerifying ? 'Проверка...' : 'Подтвердить',
            onPressed: _isVerifying || code.length != 6 ? null : _verifyCode,
            isPrimary: true,
            isFullWidth: true,
            showArrow: !_isVerifying,
          ),
        ),
      ],
    );
  }
}
