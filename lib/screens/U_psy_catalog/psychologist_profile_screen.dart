import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import 'booking_screen.dart';

/// Профиль психолога с подробной информацией
class PsychologistProfileScreen extends StatefulWidget {
  final Map<String, dynamic> psychologist;

  const PsychologistProfileScreen({Key? key, required this.psychologist})
    : super(key: key);

  @override
  State<PsychologistProfileScreen> createState() =>
      _PsychologistProfileScreenState();
}

class _PsychologistProfileScreenState extends State<PsychologistProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar с изображением
          _buildSliverAppBar(),

          // Основная информация
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildMainInfo(),
                const SizedBox(height: 20),
                _buildStatsRow(),
                const SizedBox(height: 24),
                _buildTabBar(),
              ],
            ),
          ),

          // Контент вкладок
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(),
                _buildReviewsTab(),
                _buildScheduleTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border, color: Colors.white),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.psychologist['image'], fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.psychologist['name'],
                        style: AppTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      if (widget.psychologist['isOnline']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Онлайн',
                            style: AppTextStyles.body2.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.psychologist['specialty'],
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(Icons.star, size: 24, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                '${widget.psychologist['rating']}',
                style: AppTextStyles.h2.copyWith(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                '(${widget.psychologist['reviews']} отзывов)',
                style: AppTextStyles.body2.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.work_outline,
            'Опыт работы',
            '${widget.psychologist['experience']} лет',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.payments_outlined,
            'Стоимость сессии',
            '${widget.psychologist['price']} ₸ / час',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.access_time,
            'Ближайшее время',
            widget.psychologist['nextAvailable'],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body3.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('429', 'Сессий', Icons.event_note)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('98%', 'Одобрений', Icons.thumb_up)),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('48ч', 'Ответ', Icons.access_time_filled),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3.copyWith(fontSize: 18)),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.body3.copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppColors.textWhite,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.button.copyWith(fontSize: 14),
        tabs: const [
          Tab(text: 'О себе'),
          Tab(text: 'Отзывы'),
          Tab(text: 'Расписание'),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Обо мне', style: AppTextStyles.h3.copyWith(fontSize: 20)),
          const SizedBox(height: 12),
          Text(
            'Я практикующий психолог с ${widget.psychologist['experience']} летним опытом работы. '
            'Специализируюсь на когнитивно-поведенческой терапии (КПТ) и работе с тревожными расстройствами.\n\n'
            'Помогаю людям справиться с:\n'
            '• Тревогой и паническими атаками\n'
            '• Депрессией и апатией\n'
            '• Проблемами в отношениях\n'
            '• Низкой самооценкой\n'
            '• Стрессом и выгоранием',
            style: AppTextStyles.body1.copyWith(fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 24),
          Text('Образование', style: AppTextStyles.h3.copyWith(fontSize: 20)),
          const SizedBox(height: 12),
          _buildEducationItem(
            'КазНУ им. Аль-Фараби',
            'Психология',
            '2012-2016',
          ),
          const SizedBox(height: 12),
          _buildEducationItem(
            'Институт когнитивно-поведенческой терапии',
            'КПТ-терапевт',
            '2017-2018',
          ),
          const SizedBox(height: 24),
          Text(
            'Подходы в работе',
            style: AppTextStyles.h3.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildApproachChip('КПТ'),
              _buildApproachChip('Схема-терапия'),
              _buildApproachChip('Гештальт'),
              _buildApproachChip('Mindfulness'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(String institution, String degree, String years) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  institution,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(degree, style: AppTextStyles.body2.copyWith(fontSize: 13)),
                Text(
                  years,
                  style: AppTextStyles.body3.copyWith(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproachChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          fontSize: 13,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildReviewsTab() {
    final reviews = [
      {
        'name': 'Анна К.',
        'rating': 5.0,
        'date': '15 октября 2024',
        'text':
            'Отличный специалист! Помогла разобраться с тревожностью. Очень рекомендую!',
      },
      {
        'name': 'Дмитрий М.',
        'rating': 4.8,
        'date': '10 октября 2024',
        'text':
            'Профессиональный подход, внимательное отношение. Спасибо за помощь!',
      },
      {
        'name': 'Елена С.',
        'rating': 5.0,
        'date': '5 октября 2024',
        'text':
            'Замечательный психолог. Чувствую себя намного лучше после сессий.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildReviewCard(review),
        );
      },
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['name'].toString()[0],
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: AppTextStyles.body3.copyWith(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    review['rating'].toString(),
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['text'],
            style: AppTextStyles.body1.copyWith(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Расписание на эту неделю',
            style: AppTextStyles.h3.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          _buildScheduleDay('Понедельник, 21 окт', [
            '09:00 - 10:00',
            '11:00 - 12:00',
            '15:00 - 16:00',
          ]),
          const SizedBox(height: 12),
          _buildScheduleDay('Вторник, 22 окт', [
            '10:00 - 11:00',
            '16:00 - 17:00',
          ]),
          const SizedBox(height: 12),
          _buildScheduleDay('Среда, 23 окт', [
            '09:00 - 10:00',
            '13:00 - 14:00',
            '17:00 - 18:00',
          ]),
          const SizedBox(height: 12),
          _buildScheduleDay('Четверг, 24 окт', [
            '14:00 - 15:00',
            '18:00 - 19:00',
          ]),
          const SizedBox(height: 12),
          _buildScheduleDay('Пятница, 25 окт', [
            '10:00 - 11:00',
            '15:00 - 16:00',
          ]),
        ],
      ),
    );
  }

  Widget _buildScheduleDay(String day, List<String> slots) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                day,
                style: AppTextStyles.body1.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Text(
                  slot,
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 13,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
      child: SafeArea(
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  // Открыть чат
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Записаться на сессию',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        psychologistName: widget.psychologist['name'],
                        psychologistImage: widget.psychologist['image'],
                        specialty: widget.psychologist['specialty'],
                        rating: widget.psychologist['rating'],
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
}
