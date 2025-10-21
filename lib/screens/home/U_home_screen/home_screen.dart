import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_calendar.dart';
import '../../../widgets/article_card.dart';
import '../../../widgets/session_card.dart';
import '../../U_psy_catalog/psy_catalog.dart';
import '../../U_articles/article_screen.dart';
import '../../Moodsurvey/MoodSurveyScreen.dart';
import '../../chats/U_chats/chats_screen.dart';
import '../../profile/U_profile/profile_screen.dart';
import '../../../widgets/custom_navbar.dart';

/// Главный экран приложения с современным navbar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  late AnimationController _animationController;

  final List<Widget> _screens = [
    const _HomeContent(),
    const PsychologistsScreen(),
    const ArticlesScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: _screens[selectedTab],
      bottomNavigationBar: CustomNavBar(
        currentIndex: selectedTab,
        onItemSelected: (index) {
          setState(() => selectedTab = index);
        },
      ),
    );
  }
}

/// Виджет с контентом главной страницы
class _HomeContent extends StatefulWidget {
  const _HomeContent({super.key});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  DateTime selectedDate = DateTime.now();
  String userName = 'Алдияр';

  final List<DateTime> appointmentDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 5)),
  ];

  // Данные для рекомендованных статей
  final List<Map<String, dynamic>> recommendedArticles = [
    {
      'title': 'Как прожить грусть с пользой',
      'image': 'assets/images/article/sad.png',
      'category': 'Эмоции',
      'readTime': 5,
    },
    {
      'title': 'Что делать, когда нет сил',
      'image': 'assets/images/article/depressed.png',
      'category': 'Самопомощь',
      'readTime': 6,
    },
    {
      'title': 'Почему любовь нас вдохновляет',
      'image': 'assets/images/article/love.png',
      'category': 'Отношения',
      'readTime': 7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Верхняя панель
          _buildTopBar(),

          // Контент
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Приветственная карточка
                  _buildWelcomeCard(),

                  const SizedBox(height: 24),

                  // Компактный календарь
                  CompactCalendarCard(
                    selectedDate: selectedDate,
                    onDateSelected: (date) {
                      setState(() => selectedDate = date);
                    },
                    onExpand: _showFullCalendar,
                    highlightedDates: appointmentDates,
                  ),

                  const SizedBox(height: 30),

                  // Секция "Ближайшая сессия"
                  _buildSectionHeader('Ближайшая сессия'),

                  const SizedBox(height: 16),

                  // Используем переиспользуемый виджет SessionCard
                  SessionCard(
                    psychologistName: 'Галия Аубакирова',
                    psychologistImage: 'assets/images/avatar/Galiya.png',
                    dateTime: 'Сегодня, 15:30',
                    status: 'Через 2 часа',
                    statusColor: const Color(0xFFD4A747),
                    onChatTap: () {
                      final homeState = context
                          .findAncestorStateOfType<_HomeScreenState>();
                      homeState?.setState(() {
                        homeState.selectedTab = 3;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Секция "Твоё настроение"
                  _buildSectionHeader('Твоё настроение'),

                  const SizedBox(height: 16),

                  _buildMoodTracker(),

                  const SizedBox(height: 30),

                  // Секция "Полезно для тебя"
                  _buildSectionHeader(
                    'Полезно для тебя',
                    onTap: () {
                      final homeState = context
                          .findAncestorStateOfType<_HomeScreenState>();
                      homeState?.setState(() {
                        homeState.selectedTab = 2;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Используем переиспользуемый виджет HorizontalArticlesList
                  HorizontalArticlesList(
                    articles: recommendedArticles,
                    cardWidth: 160,
                    cardHeight: 130,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Аватар с анимацией
          Hero(
            tag: 'user_avatar',
            child: GestureDetector(
              onTap: () {
                final homeState = context
                    .findAncestorStateOfType<_HomeScreenState>();
                homeState?.setState(() {
                  homeState.selectedTab = 4;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?img=60'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Дата с иконкой
          GestureDetector(
            onTap: _showFullCalendar,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    _getFormattedDate(),
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Кнопка уведомлений
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
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
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  onPressed: _showNotifications,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать,',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textWhite.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textWhite,
                        fontSize: 28,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.waving_hand,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Как ты себя чувствуешь сегодня?',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textWhite.withOpacity(0.9),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _showMoodSurvey,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textWhite,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Пройти мини-опрос',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTracker() {
    final moods = [
      {
        'image': 'assets/images/mood/mood_overjoyed.png',
        'label': 'Отлично',
        'color': const Color(0xFF4CAF50),
      },
      {
        'image': 'assets/images/mood/mood_happy.png',
        'label': 'Хорошо',
        'color': const Color(0xFF8BC34A),
      },
      {
        'image': 'assets/images/mood/mood_neutral.png',
        'label': 'Норм',
        'color': const Color(0xFFFFC107),
      },
      {
        'image': 'assets/images/mood/mood_sad.png',
        'label': 'Грустно',
        'color': const Color(0xFFFF9800),
      },
      {
        'image': 'assets/images/mood/mood_depressed.png',
        'label': 'Плохо',
        'color': const Color(0xFFF44336),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Как твоё настроение сейчас?',
            style: AppTextStyles.body1.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((mood) {
              return GestureDetector(
                onTap: () => _saveMood(mood['label'] as String),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (mood['color'] as Color).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: mood['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              mood['image'] as String,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.white,
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mood['label'] as String,
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3.copyWith(fontSize: 22)),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  'Все',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 15,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  void _showFullCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Календарь',
                style: AppTextStyles.h2.copyWith(fontSize: 24),
              ),
            ),
            Expanded(
              child: CustomCalendar(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                  Navigator.pop(context);
                },
                highlightedDates: appointmentDates,
                showFullMonth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodSurvey() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MoodSurveyScreen()),
    );
  }

  void _saveMood(String mood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Настроение "$mood" сохранено'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Перемещена функция уведомлений внутрь класса
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Уведомления',
                    style: AppTextStyles.h2.copyWith(fontSize: 24),
                  ),
                  TextButton(
                    onPressed: () {
                      // Отметить все как прочитанные
                    },
                    child: Text(
                      'Прочитать все',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Notifications list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    icon: Icons.event,
                    title: 'Напоминание о сессии',
                    message: 'Сессия у Галии Аубакировой через 2 часа',
                    time: '14:30',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    icon: Icons.article,
                    title: 'Новая статья',
                    message: 'Для вас подобрана новая статья',
                    time: 'Вчера',
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required String time,
    bool isUnread = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 15,
                        fontWeight: isUnread
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
