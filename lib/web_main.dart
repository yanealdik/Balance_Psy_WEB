import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_colors.dart';
import 'web/web_main_screen.dart';
import 'web/web_register.dart';
import 'web/web_login.dart';

/// Entry point для веб-версии Balance Psy
/// Запуск: flutter run -d chrome -t lib/web_main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BalancePsyWeb());
}

class BalancePsyWeb extends StatelessWidget {
  const BalancePsyWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancePsy - Онлайн психотерапия',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.cardBackground,
          error: AppColors.error,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WebMainScreen(),
        '/register': (context) => const WebRegisterFlow(),
        '/login': (context) => const WebLoginScreen(),
        '/web/dashboard': (context) => const WebDashboard(),
      },
    );
  }
}

/// Временный дашборд (заглушка)
class WebDashboard extends StatelessWidget {
  const WebDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Добро пожаловать в BalancePsy!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Личный кабинет в разработке'),
          ],
        ),
      ),
    );
  }
}