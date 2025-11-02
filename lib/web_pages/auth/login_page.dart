import 'package:balance_psy/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../сore/router/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void _login() async {
    try {
      await ApiService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка входа: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(), // Десктоп с прокруткой
    );
  }

  // ── МОБИЛЬНАЯ ВЕРСИЯ ─────────────────────────────────────
  Widget _buildMobileLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildLoginForm(isMobile: true),
      ),
    );
  }

  // ── ДЕСКТОПНАЯ ВЕРСИЯ С ПРОКРУТКОЙ ───────────────────────
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Левая часть — форма
        Expanded(
          flex: 5,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(40), // Уменьшено с 60
                      child: _buildLoginForm(isMobile: false),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Правая часть — иллюстрация
        Expanded(flex: 4, child: _buildIllustrationSide()),
      ],
    );
  }

  // ── ФОРМА ВХОДА (общая для мобильной и десктопной) ───────
  Widget _buildLoginForm({required bool isMobile}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 32),
          Text('Вход в аккаунт', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Рады видеть вас снова!',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          _buildEmailField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildRememberAndForgot(),
          const SizedBox(height: 28),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildSocialButtons(),
          const SizedBox(height: 28),
          _buildRegisterLink(),
        ],
      ),
    );
  }

  // ── Остальные виджеты без изменений (только мелкие правки) ──
  Widget _buildLogo() {
    return Row(
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
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextField(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Пароль', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          style: AppTextStyles.input,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Введите пароль',
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) =>
                  setState(() => _rememberMe = value ?? false),
              activeColor: AppColors.primary,
            ),
            Text('Запомнить меня', style: AppTextStyles.body2),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Забыли пароль?',
            style: AppTextStyles.body2.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CustomButton(
        text: 'Войти',
        onPressed: _canLogin ? _login : null,
        isPrimary: true,
        isFullWidth: true,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.textTertiary)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'или',
            style: AppTextStyles.body2.copyWith(color: AppColors.textTertiary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.textTertiary)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton('Google', Icons.g_mobiledata, () {}),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildSocialButton('Facebook', Icons.facebook, () {})),
      ],
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

  Widget _buildRegisterLink() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Нет аккаунта? ',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.register),
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
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 140,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Ваш путь к балансу начинается здесь',
                style: AppTextStyles.h3.copyWith(fontSize: 20),
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
