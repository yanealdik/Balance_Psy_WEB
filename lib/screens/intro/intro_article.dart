import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/back_button.dart';

/// Экран со статьей
class IntroArticleScreen extends StatefulWidget {
  const IntroArticleScreen({Key? key}) : super(key: key);

  @override
  State<IntroArticleScreen> createState() => _IntroArticleScreenState();
}

class _IntroArticleScreenState extends State<IntroArticleScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasReadToEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Проверяем, прокрутил ли пользователь до конца (или почти до конца)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasReadToEnd) {
        setState(() {
          _hasReadToEnd = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя часть с кнопкой назад
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CustomBackButton(
                    onPressed: () => Navigator.pop(context, _hasReadToEnd),
                  ),
                ],
              ),
            ),

            // Контент статьи
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Text(
                      'Как BalancePsy помогает',
                      style: AppTextStyles.h2.copyWith(fontSize: 26),
                    ),

                    const SizedBox(height: 8),

                    // Время чтения
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '3 минуты чтения',
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Изображение (опционально)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.3),
                            AppColors.primary.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_awesome,
                          size: 80,
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Текст статьи
                    _buildParagraph(
                      'Введение',
                      'BalancePsy создан на основе научных исследований в области психологии и нейробиологии. Мы объединили древние практики медитации с современными когнитивными техниками, чтобы создать эффективный инструмент для твоего благополучия.',
                    ),

                    _buildParagraph(
                      'Медитация и осознанность',
                      'Регулярная медитация помогает снизить уровень стресса, улучшить концентрацию и эмоциональную устойчивость. Исследования показывают, что всего 10 минут медитации в день могут значительно улучшить качество жизни.',
                    ),

                    _buildParagraph(
                      'Дыхательные практики',
                      'Контролируемое дыхание активирует парасимпатическую нервную систему, что приводит к естественному расслаблению. Наши упражнения основаны на техниках, доказавших свою эффективность в клинических исследованиях.',
                    ),

                    _buildParagraph(
                      'Когнитивные техники',
                      'Мы используем элементы когнитивно-поведенческой терапии (КПТ), которая признана одним из наиболее эффективных методов работы с тревогой, стрессом и негативными мыслями.',
                    ),

                    _buildParagraph(
                      'Персонализация',
                      'BalancePsy адаптируется под твои потребности. Мы отслеживаем твой прогресс и предлагаем практики, которые будут наиболее эффективны именно для тебя.',
                    ),

                    _buildParagraph(
                      'Научный подход',
                      'Все наши методики основаны на проверенных исследованиях. Мы постоянно обновляем контент, учитывая последние открытия в области психологии и нейронауки.',
                    ),

                    _buildParagraph(
                      'Заключение',
                      'BalancePsy - это не просто приложение. Это твой личный помощник на пути к внутренней гармонии и психологическому благополучию. Начни свой путь сегодня!',
                    ),

                    const SizedBox(height: 40),

                    // Индикатор прочтения
                    if (_hasReadToEnd)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Статья прочитана! Можешь продолжить',
                                style: AppTextStyles.body2.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_downward,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Прокрути до конца, чтобы продолжить',
                                style: AppTextStyles.body3.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Кнопка "Продолжить"
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: 'Продолжить',
                showArrow: true,
                onPressed: _hasReadToEnd
                    ? () => Navigator.pop(context, true)
                    : null,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTextStyles.body2.copyWith(fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}
