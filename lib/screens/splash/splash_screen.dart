import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../start/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Задержка для показа splash screen
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Проверяем, авторизован ли пользователь
    // TODO: Добавьте вашу логику проверки авторизации
    // final isAuthenticated = await checkAuth();
    // final userRole = await getUserRole(); // 'user' или 'psychologist'

    // Для примера используем StartScreen
    // В реальном приложении добавьте проверку:
    // if (isAuthenticated) {
    //   if (userRole == 'psychologist') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const MainContainer()),
    //     );
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HomeScreen()),
    //     );
    //   }
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const StartScreen()),
    //   );
    // }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 24),
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
          const Positioned(
            left: 25,
            child: Icon(Icons.face, size: 50, color: AppColors.textWhite),
          ),
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
