import 'package:balance_psy/screens/home/U_home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/back_button.dart';
import '../intro/intro_screen.dart';

/// Экран успешной регистрации - Скриншот 8
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                ],
              ),
            ),
              const SizedBox(height: 60),
              
              // Иллюстрация успеха
              Expanded(
                child: Center(
                  child: _buildSuccessIllustration(),
                ),
              ),
              
              // Текст приветствия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Добро пожаловать в BalancePsy.',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Теперь мы можем подобрать рекомендации, подходящие именно тебе.',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textWhite.withOpacity(0.9),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Кнопка "Познакомиться с BalancePsy"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  text: 'Познакомиться с BalancePsy',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IntroScreen(),
                      ),
                    );
                  }, isFullWidth: true,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Кнопка "Пропустить"
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                },
                child: Text(
                  'Пропустить',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.textWhite.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Иллюстрация успеха
  Widget _buildSuccessIllustration() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.textWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Персонаж
          Container(
            width: 120,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Center(
              child: Icon(
                Icons.emoji_emotions,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
          
          // Галочка
          Positioned(
            bottom: 30,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.textWhite,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}