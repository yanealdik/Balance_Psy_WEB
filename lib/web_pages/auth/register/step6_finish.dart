import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/WEB/web_button.dart';

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

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 48,
          vertical: isMobile ? 32 : 48,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 800,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: _buildSuccessIcon(),
              ),
              SizedBox(height: isMobile ? 40 : 56),
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
                    Text(
                      'Добро пожаловать в BalancePsy! Теперь вы можете начать работу с платформой и получить доступ ко всем функциям',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 17,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 40 : 48),
                    _buildFeaturesList(isMobile),
                    SizedBox(height: isMobile ? 40 : 48),
                    SizedBox(
                      width: isMobile ? double.infinity : 340,
                      height: 56,
                      child: WebButton(
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
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 120,
      height: 120,
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
      child: const Icon(Icons.check_circle, size: 70, color: Colors.white),
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
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Что вас ждёт:',
            style: AppTextStyles.h3.copyWith(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isMobile ? 24 : 28),
          ...features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < features.length - 1 ? 24 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: isMobile ? 52 : 56,
                    height: isMobile ? 52 : 56,
                    decoration: BoxDecoration(
                      color: (feature['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: feature['color'] as Color,
                      size: isMobile ? 26 : 28,
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
                        const SizedBox(height: 6),
                        Text(
                          feature['description'] as String,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isMobile ? 13 : 14,
                            height: 1.5,
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
