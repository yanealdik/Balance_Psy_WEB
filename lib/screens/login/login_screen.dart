import 'package:balance_psy/screens/home/P_home_screen/P_home_screen.dart';
import 'package:balance_psy/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../home/U_home_screen/home_screen.dart';

/// Экран входа в приложение
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = value.contains('@') && value.length > 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Заголовок
              Text(
                'Добро пожаловать!',
                style: AppTextStyles.h1.copyWith(fontSize: 32),
              ),

              const SizedBox(height: 40),

              // Поле "Почта"
              Text(
                'Почта',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              _buildEmailField(),

              const SizedBox(height: 24),

              // Поле "Пароль"
              Text(
                'Пароль',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              _buildPasswordField(),

              const SizedBox(height: 32),

              // Кнопка "Войти"
              CustomButton(
                text: 'Войти',
                onPressed: () {
                  // Переход на главный экран
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                icon: Icons.arrow_forward,
                isFullWidth: true,
              ),

              const SizedBox(height: 32),

              // Разделитель "или"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.textTertiary.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'или',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.textTertiary.withOpacity(0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Кнопка "Continue with Apple"
              _buildSocialButton(
                text: 'Continue with Apple',
                icon: Icons.apple,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PsychologistHomeScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Кнопка "Continue with Google"
              _buildSocialButton(
                text: 'CONTINUE WITH GOOGLE',
                icon: Icons.g_mobiledata,
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: AppColors.inputBorder,
                onPressed: () {
                  // TODO: Implement Google sign in
                },
              ),

              const SizedBox(height: 24),

              // Ссылки внизу
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement forgot password
                      },
                      child: Text(
                        'Забыли Пароль?',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Переход на экран входа
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body1.copyWith(fontSize: 14),
                          children: const [
                            TextSpan(
                              text: 'Нету аккаунта? ',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextSpan(
                              text: 'Регистрация',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '.',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Поле ввода email
  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        onChanged: _validateEmail,
        style: AppTextStyles.body1.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Введите почту',
          hintStyle: AppTextStyles.body2.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
          ),
          suffixIcon: _isEmailValid
              ? const Icon(Icons.check_circle, color: AppColors.success)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Поле ввода пароля
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: AppTextStyles.body1.copyWith(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Введите пароль',
          hintStyle: AppTextStyles.body2.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: AppColors.textSecondary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.textTertiary,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Кнопка социальной сети
  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
