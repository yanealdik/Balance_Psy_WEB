import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import 'booking_screen.dart';
import 'psychologist_profile_screen.dart';

/// Экран каталога психологов - улучшенная версия
class PsychologistsScreen extends StatefulWidget {
  const PsychologistsScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistsScreen> createState() => _PsychologistsScreenState();
}

class _PsychologistsScreenState extends State<PsychologistsScreen> {
  int selectedCategory = 0;
  String searchQuery = '';

  final List<String> categories = [
    'Все',
    'Детские',
    'Семейные',
    'Подростковые',
  ];

  final List<Map<String, dynamic>> psychologists = [
    {
      'name': 'Галия Аубакирова',
      'specialty': 'Психолог, нутрициолог',
      'description': 'взрослый и детский',
      'rating': 4.9,
      'reviews': 429,
      'experience': 8,
      'price': 8000,
      'image': 'https://i.pravatar.cc/150?img=5',
      'isOnline': true,
      'nextAvailable': 'Сегодня, 15:00',
    },
    {
      'name': 'Яна Прозорова',
      'specialty': 'Психолог (КПТ, схема терапия)',
      'description': 'работа с тревогой и депрессией',
      'rating': 4.7,
      'reviews': 136,
      'experience': 5,
      'price': 7000,
      'image': 'https://i.pravatar.cc/150?img=10',
      'isOnline': false,
      'nextAvailable': 'Завтра, 10:00',
    },
    {
      'name': 'Лаура Болдина',
      'specialty': 'Психолог (КПТ, гештальт)',
      'description': 'отношения и самооценка',
      'rating': 4.8,
      'reviews': 224,
      'experience': 6,
      'price': 7500,
      'image': 'https://i.pravatar.cc/150?img=9',
      'isOnline': true,
      'nextAvailable': 'Сегодня, 17:30',
    },
  ];

  List<Map<String, dynamic>> get filteredPsychologists {
    return psychologists.where((psy) {
      final matchesSearch = psy['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
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
              child: Text(
                'Каталог психологов',
                style: AppTextStyles.h2.copyWith(fontSize: 28),
              ),
            ),

            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(),
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 20),

            // Рекомендованная карточка
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildRecommendedCard(),
            ),

            const SizedBox(height: 24),

            // Список психологов
            Expanded(
              child: filteredPsychologists.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredPsychologists.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildPsychologistCard(
                            filteredPsychologists[index],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Поиск психолога...',
          hintStyle: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => setState(() => searchQuery = ''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(int index) {
    final isSelected = selectedCategory == index;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          categories[index],
          style: AppTextStyles.body1.copyWith(
            fontSize: 15,
            color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Рекомендовано для вас',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textWhite,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Мы подобрали специалистов по вашим интересам',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textWhite.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.textWhite,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologistCard(Map<String, dynamic> psychologist) {
    return GestureDetector(
      onTap: () {
        // Переход на профиль психолога
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PsychologistProfileScreen(
              psychologist: psychologist,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Аватар с индикатором онлайн
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(psychologist['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (psychologist['isOnline'])
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.cardBackground,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        psychologist['name'],
                        style: AppTextStyles.h3.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        psychologist['specialty'],
                        style: AppTextStyles.body2.copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (psychologist['description'].isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          psychologist['description'],
                          style: AppTextStyles.body3.copyWith(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Информация
            Row(
              children: [
                // Рейтинг
                const Icon(Icons.star, size: 18, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  '${psychologist['rating']}',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${psychologist['reviews']})',
                  style: AppTextStyles.body3.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 16),
                // Опыт
                const Icon(
                  Icons.work_outline,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${psychologist['experience']} лет',
                  style: AppTextStyles.body2.copyWith(fontSize: 13),
                ),
                const Spacer(),
                // Цена
                Text(
                  '${psychologist['price']} ₸',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Ближайшее время
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ближайшее: ${psychologist['nextAvailable']}',
                    style: AppTextStyles.body2.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка записи
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Записаться на сессию',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        psychologistName: psychologist['name'],
                        psychologistImage: psychologist['image'],
                        specialty: psychologist['specialty'],
                        rating: psychologist['rating'],
                      ),
                    ),
                  );
                }, 
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Психологи не найдены',
            style: AppTextStyles.h3.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить запрос',
            style: AppTextStyles.body2.copyWith(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }  
  }