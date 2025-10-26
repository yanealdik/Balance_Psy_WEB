import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      currentRoute: AppRouter.dashboard,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dashboard, size: 100, color: Color(0xFF57A2EB)),
              const SizedBox(height: 24),
              Text('Личный кабинет', style: AppTextStyles.h1),
              const SizedBox(height: 16),
              Text(
                'Добро пожаловать в BalancePsy!\nЛичный кабинет в разработке',
                style: AppTextStyles.body1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
