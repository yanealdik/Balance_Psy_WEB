import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

/// Главный экран психолога с заявками и расписанием
class PsychologistHomeScreen extends StatefulWidget {
  const PsychologistHomeScreen({super.key});

  @override
  State<PsychologistHomeScreen> createState() => _PsychologistHomeScreenState();
}

class _PsychologistHomeScreenState extends State<PsychologistHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Моковые данные заявок
  final List<Map<String, dynamic>> pendingRequests = [
    {
      'id': 1,
      'clientName': 'Анна Ким',
      'clientImage': 'https://i.pravatar.cc/150?img=25',
      'date': '21 октября',
      'time': '15:00',
      'format': 'video',
      'requestDate': '20 окт, 14:30',
      'issue': 'Работа с тревожностью',
      'isFirstSession': true,
    },
    {
      'id': 2,
      'clientName': 'Дмитрий Петров',
      'clientImage': 'https://i.pravatar.cc/150?img=12',
      'date': '22 октября',
      'time': '10:00',
      'format': 'chat',
      'requestDate': '20 окт, 16:15',
      'issue': 'Проблемы в отношениях',
      'isFirstSession': false,
    },
  ];

  final List<Map<String, dynamic>> upcomingSessions = [
    {
      'id': 3,
      'clientName': 'Елена Смирнова',
      'clientImage': 'https://i.pravatar.cc/150?img=30',
      'date': '20 октября',
      'time': '18:00',
      'format': 'video',
      'status': 'soon',
      'notes': 'Продолжение работы с самооценкой',
    },
    {
      'id': 4,
      'clientName': 'Максим Иванов',
      'clientImage': 'https://i.pravatar.cc/150?img=15',
      'date': '21 октября',
      'time': '11:00',
      'format': 'video',
      'status': 'today',
      'notes': 'Первая сессия',
    },
  ];

  // Статистика
  final Map<String, dynamic> stats = {
    'todaySessions': 3,
    'pendingRequests': 2,
    'weekRevenue': 42000,
    'rating': 4.9,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель
            _buildHeader(),

            // Статистика
            _buildStatsCards(),

            const SizedBox(height: 24),

            // Вкладки
            _buildTabBar(),

            const SizedBox(height: 20),

            // Контент вкладок
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildRequestsTab(), _buildSessionsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=5'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Добро пожаловать!',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Галия Аубакирова',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    _showNotificationsItem();
                  },
                ),
                if (pendingRequests.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Сегодня',
              '${stats['todaySessions']}',
              'сессий',
              Icons.event_note,
              const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              'Новые',
              '${stats['pendingRequests']}',
              'заявки',
              Icons.notifications_active,
              const Color(0xFFFF9800),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              'Неделя',
              '${(stats['weekRevenue'] / 1000).toStringAsFixed(0)}к',
              '₸',
              Icons.wallet,
              AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.body3.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.button.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.button.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Заявки'),
                if (pendingRequests.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${pendingRequests.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Tab(text: 'Расписание'),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (pendingRequests.isEmpty) {
      return _buildEmptyState(
        'Нет новых заявок',
        'Новые заявки от клиентов появятся здесь',
        Icons.notifications_none,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRequestCard(pendingRequests[index]),
        );
      },
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с пометкой "НОВАЯ"
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_new, size: 16, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Text(
                      'НОВАЯ ЗАЯВКА',
                      style: AppTextStyles.body3.copyWith(
                        fontSize: 10,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                request['requestDate'],
                style: AppTextStyles.body3.copyWith(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Информация о клиенте
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(request['clientImage']),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  if (request['isFirstSession'])
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cardBackground,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            request['clientName'],
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (request['isFirstSession']) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Новый',
                              style: AppTextStyles.body3.copyWith(
                                fontSize: 9,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['issue'],
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Детали сессии
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    Icons.calendar_today,
                    request['date'],
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.textTertiary.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildDetailItem(Icons.access_time, request['time']),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.textTertiary.withOpacity(0.2),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildDetailItem(
                    request['format'] == 'video'
                        ? Icons.videocam_outlined
                        : Icons.chat_bubble_outline,
                    request['format'] == 'video' ? 'Видео' : 'Чат',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _declineRequest(request['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text(
                    'Отклонить',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Подтвердить',
                  onPressed: () => _acceptRequest(request['id']),
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.body2.copyWith(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsTab() {
    if (upcomingSessions.isEmpty) {
      return _buildEmptyState(
        'Нет запланированных сессий',
        'Подтвержденные сессии появятся здесь',
        Icons.event_available,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: upcomingSessions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSessionCard(upcomingSessions[index]),
        );
      },
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    Color statusColor = AppColors.primary;
    String statusText = 'Скоро';

    if (session['status'] == 'soon') {
      statusColor = const Color(0xFFFF5722);
      statusText = 'Через 30 мин';
    } else if (session['status'] == 'today') {
      statusColor = AppColors.success;
      statusText = 'Сегодня';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(session['clientImage']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session['clientName'],
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${session['date']}, ${session['time']}',
                          style: AppTextStyles.body2.copyWith(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusText,
                        style: AppTextStyles.body3.copyWith(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (session['notes'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.notes, size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      session['notes'],
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.videocam_outlined, size: 18),
                  label: Text('Начать'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: 'Чат',
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.body2.copyWith(
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptRequest(int requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Заявка подтверждена!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          'Клиент получит уведомление о подтверждении сессии.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                pendingRequests.removeWhere((r) => r['id'] == requestId);
              });
            },
            child: Text('ОК'),
          ),
        ],
      ),
    );
  }

  void _declineRequest(int requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Отклонить заявку?'),
        content: Text(
          'Вы уверены, что хотите отклонить эту заявку? Клиент получит уведомление.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                pendingRequests.removeWhere((r) => r['id'] == requestId);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заявка отклонена'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('Отклонить'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Шапка модального окна
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Индикатор
                  Container(
                    width: 30,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Уведомления',
                        style: AppTextStyles.h2.copyWith(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.backgroundLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Список уведомлений
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildNotificationItem(
                    icon: Icons.event_available,
                    title: 'Новая заявка',
                    message: 'Анна Ким хочет записаться на консультацию',
                    time: '5 мин',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    icon: Icons.message,
                    title: 'Новое сообщение',
                    message: 'Дмитрий Петров отправил сообщение',
                    time: '1 час',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    icon: Icons.payment,
                    title: 'Платеж получен',
                    message: 'Поступила оплата за консультацию',
                    time: '2 часа',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    icon: Icons.schedule,
                    title: 'Напоминание',
                    message: 'Через 30 минут начнется сессия с Еленой',
                    time: '3 часа',
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
