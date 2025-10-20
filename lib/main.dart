import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/app_colors.dart';

void main() {
  // Устанавливаем ориентацию только портретная
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const BalancePsyApp());
}

class BalancePsyApp extends StatelessWidget {
  const BalancePsyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancePsy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Manrope', // Можно заменить на системный шрифт
      ),
      home: const SplashScreen(),
    );
  }
}