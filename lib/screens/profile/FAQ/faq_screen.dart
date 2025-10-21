import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Экран FAQ - Помощь и поддержка
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<FAQItem> _faqItems = [
    FAQItem(
      category: 'Общие вопросы',
      icon: Icons.help_outline,
      questions: [
        Question(
          question: 'Что такое BalancePsy?',
          answer:
              'BalancePsy — это современная платформа для психологической поддержки и самопомощи. Мы помогаем людям улучшить ментальное здоровье через медитации, упражнения и консультации с профессионалами.',
        ),
        Question(
          question: 'Как начать использовать приложение?',
          answer:
              'Создайте аккаунт, заполните профиль и пройдите первичную диагностику. После этого вы получите персональные рекомендации и доступ ко всем функциям приложения.',
        ),
        Question(
          question: 'Приложение бесплатное?',
          answer:
              'Базовые функции приложения бесплатны. Премиум-подписка открывает доступ к расширенным возможностям: персональным консультациям, дополнительным курсам и углубленной аналитике.',
        ),
      ],
    ),
    FAQItem(
      category: 'Аккаунт и безопасность',
      icon: Icons.security_outlined,
      questions: [
        Question(
          question: 'Как изменить пароль?',
          answer:
              'Перейдите в Настройки → Безопасность → Изменить пароль. Введите текущий пароль и новый пароль дважды для подтверждения.',
        ),
        Question(
          question: 'Мои данные защищены?',
          answer:
              'Да, мы используем шифрование данных и соблюдаем все стандарты конфиденциальности. Ваша информация хранится на защищенных серверах и не передается третьим лицам без вашего согласия.',
        ),
        Question(
          question: 'Как удалить аккаунт?',
          answer:
              'Зайдите в Настройки → Аккаунт → Удалить аккаунт. Обратите внимание, что это действие необратимо и все ваши данные будут удалены.',
        ),
      ],
    ),
    FAQItem(
      category: 'Функции приложения',
      icon: Icons.apps_outlined,
      questions: [
        Question(
          question: 'Как отслеживать свой прогресс?',
          answer:
              'В разделе "Прогресс" вы найдете детальную статистику: настроение, выполненные упражнения, пройденные курсы и достижения.',
        ),
        Question(
          question: 'Что такое дневник настроения?',
          answer:
              'Дневник настроения помогает отслеживать эмоциональное состояние. Ежедневно отмечайте свое настроение и получайте аналитику по динамике эмоций.',
        ),
        Question(
          question: 'Как работают напоминания?',
          answer:
              'Вы можете настроить уведомления для медитаций, упражнений и записи в дневник. Перейдите в Настройки → Уведомления для настройки.',
        ),
      ],
    ),
    FAQItem(
      category: 'Консультации',
      icon: Icons.psychology_outlined,
      questions: [
        Question(
          question: 'Как записаться на консультацию?',
          answer:
              'Перейдите в раздел "Специалисты", выберите психолога и нажмите "Записаться". Выберите удобное время и подтвердите запись.',
        ),
        Question(
          question: 'Как проходят онлайн-сессии?',
          answer:
              'Сессии проводятся через встроенный видеочат. За 5 минут до начала вы получите уведомление и сможете присоединиться к звонку.',
        ),
        Question(
          question: 'Можно ли отменить или перенести консультацию?',
          answer:
              'Да, вы можете отменить или перенести консультацию не позднее чем за 24 часа до начала. Перейдите в раздел "Мои записи" и выберите нужную консультацию.',
        ),
      ],
    ),
    FAQItem(
      category: 'Технические вопросы',
      icon: Icons.settings_outlined,
      questions: [
        Question(
          question: 'Приложение не открывается',
          answer:
              'Попробуйте перезапустить приложение. Убедитесь, что у вас установлена последняя версия. Если проблема сохраняется, переустановите приложение.',
        ),
        Question(
          question: 'Проблемы со звуком в медитациях',
          answer:
              'Проверьте громкость устройства и убедитесь, что приложению разрешен доступ к аудио. Попробуйте переключить наушники или динамик.',
        ),
        Question(
          question: 'Как обновить приложение?',
          answer:
              'Зайдите в App Store или Google Play, найдите BalancePsy и нажмите "Обновить" если доступна новая версия.',
        ),
      ],
    ),
  ];

  List<FAQItem> get _filteredFAQItems {
    if (_searchQuery.isEmpty) {
      return _faqItems;
    }

    return _faqItems
        .map((category) {
          final filteredQuestions = category.questions.where((q) {
            return q.question.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                q.answer.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return FAQItem(
            category: category.category,
            icon: category.icon,
            questions: filteredQuestions,
          );
        })
        .where((category) => category.questions.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredFAQItems;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Помощь и поддержка', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Поиск
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.body1,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _expandedIndex = null;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.background,
                  hintText: 'Поиск по вопросам...',
                  hintStyle: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Список FAQ
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ничего не найдено',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Попробуйте изменить запрос',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = filteredItems[categoryIndex];
                        return _buildCategorySection(
                          category: category,
                          categoryIndex: categoryIndex,
                        );
                      },
                    ),
            ),

            // Контакты поддержки
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Не нашли ответ?',
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          onTap: () {
                            // TODO: Открыть email клиент
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.chat_bubble_outline,
                          label: 'Чат',
                          onTap: () {
                            // TODO: Открыть чат поддержки
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required FAQItem category,
    required int categoryIndex,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок категории
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                category.category,
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),

        // Вопросы категории
        ...List.generate(category.questions.length, (questionIndex) {
          final globalIndex = categoryIndex * 100 + questionIndex;
          final question = category.questions[questionIndex];
          final isExpanded = _expandedIndex == globalIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isExpanded
                      ? AppColors.primary.withOpacity(0.3)
                      : AppColors.inputBorder.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : globalIndex;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Вопрос
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question.question,
                                  style: AppTextStyles.body1.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),

                          // Ответ
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                question.answer,
                                style: AppTextStyles.body2.copyWith(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            crossFadeState: isExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textWhite, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: AppColors.textWhite,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Модели данных
class FAQItem {
  final String category;
  final IconData icon;
  final List<Question> questions;

  FAQItem({
    required this.category,
    required this.icon,
    required this.questions,
  });
}

class Question {
  final String question;
  final String answer;

  Question({required this.question, required this.answer});
}
