import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

/// Страница входа в систему
class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canLogin =>
      _emailController.text.contains('@') &&
      _passwordController.text.length >= 6;

  void _login() {
    // TODO: Авторизация
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
          // Левая часть - форма входа
          Expanded(flex: 5, child: _buildLoginForm()),
          // Правая часть - иллюстрация
          Expanded(flex: 4, child: _buildIllustrationSide()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(child: SingleChildScrollView(child: _buildLoginForm())),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Логотип
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 28,
                ),
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
          const SizedBox(height: 48),
          Text('Вход в аккаунт', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Рады видеть вас снова!',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),

          // Email
          Text('Email', style: AppTextStyles.body1),
          const SizedBox(height: 8),
          TextField(
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 24),

          // Пароль
          Text('Пароль', style: AppTextStyles.body1),
          const SizedBox(height: 8),
          TextField(
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Запомнить меня и восстановление
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Text('Запомнить меня', style: AppTextStyles.body2),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Восстановление пароля
                },
                child: Text(
                  'Забыли пароль?',
                  style: AppTextStyles.body2.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Кнопка входа
          SizedBox(
            width: double.infinity,
            height: 56,
            child: CustomButton(
              text: 'Войти',
              onPressed: _canLogin ? _login : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
          const SizedBox(height: 24),

          // Разделитель
          Row(
            children: [
              Expanded(child: Divider(color: AppColors.textTertiary)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'или',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 24),

          // Социальные сети
          Row(
            children: [
              Expanded(
                child: _buildSocialButton('Google', Icons.g_mobiledata, () {}),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton('Facebook', Icons.facebook, () {}),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Регистрация
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Нет аккаунта? ',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Зарегистрироваться',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: AppColors.inputBorder, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
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
                Icons.psychology_outlined,
                size: 150,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Ваш путь к балансу начинается здесь',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'Профессиональная психологическая поддержка онлайн',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
