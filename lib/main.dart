import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/P_main_navbar/main_nav.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/P_main_navbar/main_nav.dart';
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
  const BalancePsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancePsy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Manrope', // Можно заменить на системный шрифт
        
        // Дополнительные настройки темы для лучшего вида
        useMaterial3: true,
        
        // Цветовая схема
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.cardBackground,
          error: AppColors.error,
        ),
        
        // Стиль AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
        
        // Стиль кнопок
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        
        // Стиль текстовых полей
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
      
      // Определяем роуты
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainContainer(),
      },
    );
  }
}