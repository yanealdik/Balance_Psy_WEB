import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/psychologist/reports/patient_card_widget.dart';
import '../../widgets/psychologist/reports/stat_card_widget.dart';

/// Экран отчетов психолога с иерархической структурой:
/// Дата → Пациенты → История посещений
class PsychologistReportsScreen extends StatefulWidget {
  const PsychologistReportsScreen({super.key});

  @override
  State<PsychologistReportsScreen> createState() =>
      _PsychologistReportsScreenState();
}

class _PsychologistReportsScreenState extends State<PsychologistReportsScreen> {
  // Структура: Map<дата, Map<пациент, List<отчеты>>>
  Map<String, Map<String, List<Map<String, dynamic>>>> groupedReports = {};

  @override
  void initState() {
    super.initState();
    _initializeReports();
  }

  void _initializeReports() {
    final allReports = [
      {
        'name': 'Алдияр Байділда',
        'image': 'https://i.pravatar.cc/150?img=60',
        'theme': 'Тревожность',
        'type': 'Групповая',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'content':
            'Пациент испытывает повышенную тревожность в связи с рабочими обязанностями. Проведена когнитивно-поведенческая терапия.',
        'recommendations':
            'Рекомендованы дыхательные упражнения и медитация перед сном. Повторная встреча через неделю.',
      },
      {
        'name': 'Алдияр Байділда',
        'image': 'https://i.pravatar.cc/150?img=60',
        'theme': 'Работа с эмоциями',
        'type': 'Индивидуальная',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'content':
            'Продолжение работы с тревожностью. Пациент показывает прогресс.',
        'recommendations': 'Продолжить практики осознанности.',
      },
      {
        'name': 'Рамина Канатовна',
        'image': 'https://i.pravatar.cc/150?img=45',
        'theme': 'Влюбленность',
        'type': 'Индивидуальная',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'content':
            'Обсуждены чувства пациента и способы здорового выражения эмоций в отношениях.',
        'recommendations':
            'Прочитать статью "Как говорить о чувствах". Практиковать открытое общение с партнером.',
      },
      {
        'name': 'Ажар Алимбет',
        'image': 'https://i.pravatar.cc/150?img=32',
        'theme': 'Депрессия',
        'type': 'Групповая',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'content':
            'Пациент находится в состоянии легкой депрессии. Обсуждены триггеры и методы самопомощи.',
        'recommendations':
            'Продолжить ведение дневника эмоций. Рассмотреть возможность медикаментозной терапии.',
      },
      {
        'name': 'Айгуль Сериккызы',
        'image': 'https://i.pravatar.cc/150?img=27',
        'theme': 'Стресс на работе',
        'type': 'Индивидуальная',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'content':
            'Высокий уровень стресса из-за конфликтов с коллегами. Проработаны стратегии коммуникации.',
        'recommendations':
            'Применять техники ассертивности. Установить границы в рабочих отношениях.',
      },
      {
        'name': 'Нурлан Ержанов',
        'image': 'https://i.pravatar.cc/150?img=12',
        'theme': 'Семейные проблемы',
        'type': 'Индивидуальная',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'content':
            'Обсуждены конфликты в семье и способы улучшения коммуникации с супругой.',
        'recommendations':
            'Парная терапия с супругой. Практиковать активное слушание.',
      },
    ];

    // Группируем отчеты по датам и пациентам
    for (var report in allReports) {
      final dateKey = _getDateKey(report['date'] as DateTime);
      final patientName = report['name'] as String;

      if (!groupedReports.containsKey(dateKey)) {
        groupedReports[dateKey] = {};
      }

      if (!groupedReports[dateKey]!.containsKey(patientName)) {
        groupedReports[dateKey]![patientName] = [];
      }

      groupedReports[dateKey]![patientName]!.add(report);
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int get totalReports {
    int count = 0;
    groupedReports.forEach((date, patients) {
      patients.forEach((patient, reports) {
        count += reports.length;
      });
    });
    return count;
  }

  int get weekReports {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    int count = 0;
    groupedReports.forEach((dateKey, patients) {
      patients.forEach((patient, reports) {
        for (var report in reports) {
          if ((report['date'] as DateTime).isAfter(weekAgo)) {
            count++;
          }
        }
      });
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = groupedReports.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Новые даты сверху

    return Material(
      color: AppColors.backgroundLight,
      child: Stack(
        children: [
          SafeArea(
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
                        child: StatCardWidget(
                          number: totalReports.toString(),
                          label: 'всего отчетов',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCardWidget(
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
                  child: Text(
                    'По датам',
                    style: AppTextStyles.h3.copyWith(fontSize: 22),
                  ),
                ),

                const SizedBox(height: 16),

                // Список дат
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateKey = sortedDates[index];
                      final patients = groupedReports[dateKey]!;
                      final patientCount = patients.length;
                      final date = DateTime.parse(dateKey);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildDateCard(date, patientCount, patients),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Плавающая кнопка добавления (для MVP)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () => _showAddReportDialog(),
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(
                Icons.add,
                color: AppColors.textWhite,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Карточка даты
  Widget _buildDateCard(
    DateTime date,
    int patientCount,
    Map<String, List<Map<String, dynamic>>> patients,
  ) {
    return GestureDetector(
      onTap: () => _navigateToDateDetails(date, patients),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Иконка календаря
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDateString(date),
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$patientCount ${_getPatientsWord(patientCount)}',
                    style: AppTextStyles.body2.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _getPatientsWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'пациент';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'пациента';
    } else {
      return 'пациентов';
    }
  }

  // Переход к экрану с пациентами за конкретную дату
  void _navigateToDateDetails(
    DateTime date,
    Map<String, List<Map<String, dynamic>>> patients,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _DatePatientsScreen(
          date: date,
          patients: patients,
          onPatientTap: (patientName, reports) {
            _navigateToPatientHistory(patientName, reports);
          },
        ),
      ),
    );
  }

  // Переход к истории посещений пациента
  void _navigateToPatientHistory(
    String patientName,
    List<Map<String, dynamic>> reports,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PatientHistoryScreen(
          patientName: patientName,
          reports: reports,
          onReportTap: (report) => _showReportDetail(report),
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
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Хэндл
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(20),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['name'],
                          style: AppTextStyles.h3.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDateString(report['date']),
                          style: AppTextStyles.body2.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Контент
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Тип сеанса
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report['type'],
                            style: AppTextStyles.body2.copyWith(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Тема
                    Text(
                      'Тема сеанса',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 24),
                    // Описание сеанса
                    Text(
                      'Описание сеанса',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report['content'],
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Рекомендации
                    Text(
                      'Рекомендации',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
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

  // Диалог добавления отчета (временно для MVP)
  void _showAddReportDialog() {
    final nameController = TextEditingController();
    final themeController = TextEditingController();
    final contentController = TextEditingController();
    final recommendationsController = TextEditingController();
    String selectedType = 'Индивидуальная';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Тип сеанса',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Индивидуальная', 'Групповая']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: themeController,
                  decoration: InputDecoration(
                    labelText: 'Тема сеанса',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                  final newReport = {
                    'name': nameController.text,
                    'image':
                        'https://i.pravatar.cc/150?img=${DateTime.now().millisecond}',
                    'theme': themeController.text,
                    'type': selectedType,
                    'date': DateTime.now(),
                    'content': contentController.text,
                    'recommendations': recommendationsController.text.isEmpty
                        ? 'Рекомендации не указаны'
                        : recommendationsController.text,
                  };

                  setState(() {
                    final dateKey = _getDateKey(newReport['date'] as DateTime);
                    final patientName = newReport['name'] as String;

                    if (!groupedReports.containsKey(dateKey)) {
                      groupedReports[dateKey] = {};
                    }

                    if (!groupedReports[dateKey]!.containsKey(patientName)) {
                      groupedReports[dateKey]![patientName] = [];
                    }

                    groupedReports[dateKey]![patientName]!.insert(0, newReport);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
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

// Экран пациентов за конкретную дату
class _DatePatientsScreen extends StatelessWidget {
  final DateTime date;
  final Map<String, List<Map<String, dynamic>>> patients;
  final Function(String, List<Map<String, dynamic>>) onPatientTap;

  const _DatePatientsScreen({
    required this.date,
    required this.patients,
    required this.onPatientTap,
  });

  @override
  Widget build(BuildContext context) {
    final patientNames = patients.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getDateString(date),
          style: AppTextStyles.h2.copyWith(fontSize: 24),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: patientNames.length,
        itemBuilder: (context, index) {
          final patientName = patientNames[index];
          final reports = patients[patientName]!;
          final sessionCount = reports.length;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PatientCardWidget(
              name: patientName,
              imageUrl: reports.first['image'],
              sessionCount: sessionCount,
              lastTheme: reports.first['theme'],
              onTap: () => onPatientTap(patientName, reports),
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

// Экран истории посещений пациента
class _PatientHistoryScreen extends StatelessWidget {
  final String patientName;
  final List<Map<String, dynamic>> reports;
  final Function(Map<String, dynamic>) onReportTap;

  const _PatientHistoryScreen({
    required this.patientName,
    required this.reports,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
    // Сортируем по дате (новые сверху)
    final sortedReports = List<Map<String, dynamic>>.from(reports);
    sortedReports.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(patientName, style: AppTextStyles.h2.copyWith(fontSize: 20)),
            Text(
              'История посещений',
              style: AppTextStyles.body2.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: sortedReports.length,
        itemBuilder: (context, index) {
          final report = sortedReports[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildHistoryCard(report),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> report) {
    return GestureDetector(
      onTap: () => onReportTap(report),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report['type'],
                    style: AppTextStyles.body2.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  _getDateString(report['date']),
                  style: AppTextStyles.body2.copyWith(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report['theme'],
              style: AppTextStyles.h3.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              report['content'],
              style: AppTextStyles.body2.copyWith(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Подробнее',
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
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
