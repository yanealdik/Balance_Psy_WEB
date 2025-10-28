import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

class Step6Finish extends StatefulWidget {
  final VoidCallback onComplete;

  const Step6Finish({super.key, required this.onComplete});

  @override
  State<Step6Finish> createState() => _Step6FinishState();
}

class _Step6FinishState extends State<Step6Finish>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 60),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildSuccessIcon(),
                ),
                SizedBox(height: isMobile ? 32 : 48),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Регистрация завершена!',
                        style: (isMobile ? AppTextStyles.h2 : AppTextStyles.h1)
                            .copyWith(fontSize: isMobile ? 28 : 36),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 0 : 40,
                        ),
                        child: Text(
                          'Добро пожаловать в BalancePsy! Теперь вы можете начать работу с платформой и получить доступ ко всем функциям',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isMobile ? 40 : 56),
                      _buildFeaturesList(isMobile),
                      SizedBox(height: isMobile ? 40 : 56),
                      SizedBox(
                        width: isMobile ? double.infinity : 320,
                        height: 56,
                        child: CustomButton(
                          text: 'Перейти в личный кабинет',
                          onPressed: widget.onComplete,
                          isPrimary: true,
                          isFullWidth: true,
                          showArrow: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.check_circle, size: 80, color: Colors.white),
    );
  }

  Widget _buildFeaturesList(bool isMobile) {
    final features = [
      {
        'icon': Icons.psychology_outlined,
        'title': 'Консультации с психологами',
        'description': 'Выбирайте специалистов и записывайтесь на сеансы',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.assessment_outlined,
        'title': 'Психологические тесты',
        'description': 'Проходите тесты и получайте персональные рекомендации',
        'color': Color(0xFF9C27B0),
      },
      {
        'icon': Icons.article_outlined,
        'title': 'Образовательные материалы',
        'description': 'Статьи, видео и упражнения для саморазвития',
        'color': Color(0xFF00BCD4),
      },
      {
        'icon': Icons.track_changes_outlined,
        'title': 'Отслеживание прогресса',
        'description': 'Следите за своим психологическим состоянием',
        'color': Color(0xFF4CAF50),
      },
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Что вас ждёт:',
            style: AppTextStyles.h3.copyWith(fontSize: isMobile ? 18 : 20),
          ),
          SizedBox(height: isMobile ? 20 : 24),
          ...features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isMobile ? 48 : 56,
                    height: isMobile ? 48 : 56,
                    decoration: BoxDecoration(
                      color: (feature['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: feature['color'] as Color,
                      size: isMobile ? 24 : 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature['title'] as String,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: isMobile ? 15 : 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature['description'] as String,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 13 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
