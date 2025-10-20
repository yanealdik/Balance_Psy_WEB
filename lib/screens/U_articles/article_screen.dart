import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/article_card.dart';

/// Экран полезных статей - рефакторенная версия
class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  int selectedCategory = 0;

  final List<String> categories = ['Все', 'Эмоции', 'Самопомощь', 'Отношения'];

  // Все статьи с категориями
  final Map<String, List<Map<String, dynamic>>> articlesBySection = {
    'Самое популярное': [
      {
        'title': 'Радость без причины',
        'image': 'assets/images/article/happy.png',
        'category': 'Эмоции',
        'readTime': 3,
      },
      {
        'title': 'Почему я чувствую пустоту',
        'image': 'assets/images/article/empty.png',
        'category': 'Эмоции',
        'readTime': 7,
      },
      {
        'title': 'Как отпустить обиду',
        'image': 'assets/images/article/givesad.png',
        'category': 'Эмоции',
        'readTime': 5,
      },
    ],
    'Самопомощь': [
      {
        'title': '5 минут тишины',
        'image': 'assets/images/article/5min.png',
        'category': 'Самопомощь',
        'readTime': 3,
      },
      {
        'title': 'Как перестать себя ругать',
        'image': 'assets/images/article/dontAgro.png',
        'category': 'Самопомощь',
        'readTime': 6,
      },
      {
        'title': 'Дыши осознанно',
        'image': 'assets/images/article/calm.png',
        'category': 'Самопомощь',
        'readTime': 4,
      },
    ],
    'Отношения': [
      {
        'title': 'Почему я привязываюсь',
        'image': 'assets/images/article/whyIlove.png',
        'category': 'Отношения',
        'readTime': 5,
      },
      {
        'title': 'Как говорить о чувствах',
        'image': 'assets/images/article/sense.png',
        'category': 'Отношения',
        'readTime': 4,
      },
      {
        'title': 'Что делать, если отношения выгорают',
        'image': 'assets/images/article/firelove.png',
        'category': 'Отношения',
        'readTime': 8,
      },
    ],
    'Состояние покоя': [
      {
        'title': 'Вечерняя перезагрузка',
        'image': 'assets/images/article/evening.png',
        'category': 'Самопомощь',
        'readTime': 5,
      },
      {
        'title': 'Тело и эмоции: связь',
        'image': 'assets/images/article/body.png',
        'category': 'Эмоции',
        'readTime': 6,
      },
      {
        'title': 'Осознанное дыхание перед сном',
        'image': 'assets/images/article/sleep.png',
        'category': 'Самопомощь',
        'readTime': 4,
      },
    ],
  };

  // Фильтруем статьи по выбранной категории
  Map<String, List<Map<String, dynamic>>> get filteredArticles {
    if (selectedCategory == 0) {
      return articlesBySection;
    }

    final selectedCategoryName = categories[selectedCategory];
    Map<String, List<Map<String, dynamic>>> filtered = {};

    articlesBySection.forEach((section, articles) {
      final filteredList = articles
          .where((article) => article['category'] == selectedCategoryName)
          .toList();

      if (filteredList.isNotEmpty) {
        filtered[section] = filteredList;
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Полезные статьи',
                    style: AppTextStyles.h2.copyWith(fontSize: 28),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Категории
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildCategoryChip(index),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Контент со скроллом
            Expanded(
              child: filteredArticles.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSections(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Генерируем секции статей
  List<Widget> _buildSections() {
    List<Widget> sections = [];

    filteredArticles.forEach((sectionTitle, articles) {
      sections.addAll([
        _buildSectionTitle(sectionTitle),
        const SizedBox(height: 16),
        HorizontalArticlesList(articles: articles),
        const SizedBox(height: 32),
      ]);
    });

    // Убираем последний отступ
    if (sections.isNotEmpty) {
      sections.removeLast();
      sections.add(const SizedBox(height: 30));
    }

    return sections;
  }

  // Категория (чип)
  Widget _buildCategoryChip(int index) {
    final isSelected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          categories[index],
          style: AppTextStyles.body1.copyWith(
            fontSize: 15,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // Заголовок секции
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.h3.copyWith(fontSize: 22)),
      ],
    );
  }

  // Пустое состояние при фильтрации
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.article_outlined,
              size: 64,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Статей не найдено',
            style: AppTextStyles.h3.copyWith(
              fontSize: 20,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'В этой категории пока нет статей',
            style: AppTextStyles.body2.copyWith(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              setState(() {
                selectedCategory = 0;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Показать все статьи',
              style: AppTextStyles.button.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
