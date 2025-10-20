import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../start/start_screen.dart';

/// Экран загрузки (Splash Screen) - Скриншот 1
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Автоматический переход на Welcome Screen через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Верхняя часть (статус бар область)
            const SizedBox(height: 40),

            // Центральная часть с логотипом
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Логотип (замена на Container, т.к. у нас нет SVG)
                    _buildLogo(),
                    const SizedBox(height: 24),

                    // Название приложения
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Balance',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: 'Psy',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Создаем простой логотип (замена SVG)
  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primaryLight.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Иконка головы (профиль)
          const Positioned(
            left: 25,
            child: Icon(Icons.face, size: 50, color: AppColors.textWhite),
          ),
          // Иконка весов
          Positioned(
            right: 20,
            child: Icon(
              Icons.balance,
              size: 45,
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
