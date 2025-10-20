import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Экран отчетов психолога
class PsychologistReportsScreen extends StatefulWidget {
  const PsychologistReportsScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistReportsScreen> createState() =>
      _PsychologistReportsScreenState();
}

class _PsychologistReportsScreenState extends State<PsychologistReportsScreen> {
  List<Map<String, dynamic>> allReports = [
    {
      'name': 'Алдияр Байділда',
      'image': 'https://i.pravatar.cc/150?img=60',
      'theme': 'Тревожность',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'content':
          'Пациент испытывает повышенную тревожность в связи с рабочими обязанностями. Проведена когнитивно-поведенческая терапия.',
      'recommendations':
          'Рекомендованы дыхательные упражнения и медитация перед сном. Повторная встреча через неделю.',
    },
    {
      'name': 'Рамина Канатовна',
      'image': 'https://i.pravatar.cc/150?img=45',
      'theme': 'Влюбленность',
      'date': DateTime.now().subtract(Duration(days: 3)),
      'content':
          'Обсуждены чувства пациента и способы здорового выражения эмоций в отношениях.',
      'recommendations':
          'Прочитать статью "Как говорить о чувствах". Практиковать открытое общение с партнером.',
    },
    {
      'name': 'Ажар Алимбет',
      'image': 'https://i.pravatar.cc/150?img=32',
      'theme': 'Депрессия',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'content':
          'Пациент находится в состоянии легкой депрессии. Обсуждены триггеры и методы самопомощи.',
      'recommendations':
          'Продолжить ведение дневника эмоций. Рассмотреть возможность медикаментозной терапии.',
    },
    {
      'name': 'Айгуль Сериккызы',
      'image': 'https://i.pravatar.cc/150?img=27',
      'theme': 'Стресс на работе',
      'date': DateTime.now().subtract(Duration(days: 7)),
      'content':
          'Высокий уровень стресса из-за конфликтов с коллегами. Проработаны стратегии коммуникации.',
      'recommendations':
          'Применять техники ассертивности. Установить границы в рабочих отношениях.',
    },
    {
      'name': 'Нурлан Ержанов',
      'image': 'https://i.pravatar.cc/150?img=12',
      'theme': 'Семейные проблемы',
      'date': DateTime.now().subtract(Duration(days: 10)),
      'content':
          'Обсуждены конфликты в семье и способы улучшения коммуникации с супругой.',
      'recommendations':
          'Парная терапия с супругой. Практиковать активное слушание.',
    },
  ];

  int get totalReports => allReports.length;
  int get weekReports {
    final weekAgo = DateTime.now().subtract(Duration(days: 7));
    return allReports.where((report) {
      return (report['date'] as DateTime).isAfter(weekAgo);
    }).length;
  }

  List<Map<String, dynamic>> get recentReports {
    final sorted = List<Map<String, dynamic>>.from(allReports);
    sorted.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );
    return sorted.take(2).toList();
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Text(
                'Мои отчеты',
                style: AppTextStyles.h2.copyWith(fontSize: 28),
              ),
            ),

            // Статистика
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      number: totalReports.toString(),
                      label: 'всего отчетов',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      number: weekReports.toString(),
                      label: 'за эту неделю',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Заголовок секции
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Последние отчеты',
                    style: AppTextStyles.h3.copyWith(fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () => _showAllReports(),
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
              ),
            ),

            const SizedBox(height: 16),

            // Список отчетов
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recentReports.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildReportCard(recentReports[index]),
                  );
                },
              ),
            ),

            // Кнопка добавления
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.textWhite,
                      size: 28,
                    ),
                    onPressed: () => _showAddReportDialog(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка статистики
  Widget _buildStatCard({required String number, required String label}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppTextStyles.h1.copyWith(
              fontSize: 48,
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              fontSize: 14,
              color: AppColors.textWhite,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Карточка отчета
  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Аватар
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(report['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['name'],
                      style: AppTextStyles.h3.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Тема: ${report['theme']}',
                      style: AppTextStyles.body2.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Кнопка просмотра
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => _showReportDetail(report),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
              ),
              child: Text(
                'Посмотреть',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textWhite,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Показать все отчеты
  void _showAllReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AllReportsScreen(
          reports: allReports,
          onDelete: (index) {
            setState(() {
              allReports.removeAt(index);
            });
          },
          onView: (report) => _showReportDetail(report),
        ),
      ),
    );
  }

  // Показать детали отчета
  void _showReportDetail(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Хэндл
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Заголовок
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(report['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['name'],
                          style: AppTextStyles.h3.copyWith(fontSize: 20),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _getDateString(report['date']),
                          style: AppTextStyles.body2.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Тема
                    Text(
                      'Тема сеанса',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        report['theme'],
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Описание сеанса
                    Text(
                      'Описание сеанса',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      report['content'],
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Рекомендации
                    Text(
                      'Рекомендации',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        report['recommendations'],
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Диалог добавления отчета
  void _showAddReportDialog() {
    final nameController = TextEditingController();
    final themeController = TextEditingController();
    final contentController = TextEditingController();
    final recommendationsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Добавить отчет',
          style: AppTextStyles.h3.copyWith(fontSize: 20),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Имя пациента',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: themeController,
                decoration: InputDecoration(
                  labelText: 'Тема сеанса',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Описание сеанса',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              TextField(
                controller: recommendationsController,
                decoration: InputDecoration(
                  labelText: 'Рекомендации',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: AppTextStyles.body1.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  themeController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                setState(() {
                  allReports.insert(0, {
                    'name': nameController.text,
                    'image':
                        'https://i.pravatar.cc/150?img=${allReports.length + 50}',
                    'theme': themeController.text,
                    'date': DateTime.now(),
                    'content': contentController.text,
                    'recommendations': recommendationsController.text.isEmpty
                        ? 'Рекомендации не указаны'
                        : recommendationsController.text,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Отчет успешно добавлен'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text(
              'Добавить',
              style: AppTextStyles.body1.copyWith(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDateString(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// Экран всех отчетов
class _AllReportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final Function(int) onDelete;
  final Function(Map<String, dynamic>) onView;

  const _AllReportsScreen({
    required this.reports,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Все отчеты',
          style: AppTextStyles.h2.copyWith(fontSize: 24),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Dismissible(
              key: Key(report['name'] + index.toString()),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Удалить отчет?'),
                    content: Text('Это действие нельзя отменить.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Удалить',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) {
                onDelete(index);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Отчет удалён')));
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () => onView(report),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(report['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report['name'],
                              style: AppTextStyles.h3.copyWith(fontSize: 17),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Тема: ${report['theme']}',
                              style: AppTextStyles.body2.copyWith(fontSize: 13),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _getDateString(report['date']),
                              style: AppTextStyles.body2.copyWith(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDateString(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
