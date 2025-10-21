import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'Appointment/appointment.dart' hide GestureDetector, Container, SizedBox;

/// Экран расписания приёмов психолога
class PsychologistScheduleScreen extends StatefulWidget {
  const PsychologistScheduleScreen({super.key});

  @override
  State<PsychologistScheduleScreen> createState() =>
      _PsychologistScheduleScreenState();
}

class _PsychologistScheduleScreenState
    extends State<PsychologistScheduleScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime displayedMonth = DateTime.now();

  List<Map<String, dynamic>> allAppointments = [
    {
      'name': 'Алдияр Байділда',
      'image': 'https://i.pravatar.cc/150?img=60',
      'date': DateTime.now(),
      'time': '15:30',
      'status': 'Ожидается',
      'statusColor': const Color(0xFFFFF4E0),
      'statusTextColor': const Color(0xFFD4A747),
    },
    {
      'name': 'Рамина Канатовна',
      'image': 'https://i.pravatar.cc/150?img=45',
      'date': DateTime.now(),
      'time': '17:00',
      'status': 'Ожидается',
      'statusColor': const Color(0xFFFFF4E0),
      'statusTextColor': const Color(0xFFD4A747),
    },
    {
      'name': 'Ажар Алимбет',
      'image': 'https://i.pravatar.cc/150?img=32',
      'date': DateTime.now(),
      'time': '20:30',
      'status': 'отменен',
      'statusColor': const Color(0xFFFFE8E8),
      'statusTextColor': AppColors.error,
    },
    {
      'name': 'Айгуль Сериккызы',
      'image': 'https://i.pravatar.cc/150?img=27',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '10:00',
      'status': 'Ожидается',
      'statusColor': const Color(0xFFFFF4E0),
      'statusTextColor': const Color(0xFFD4A747),
    },
    {
      'name': 'Нурлан Ержанов',
      'image': 'https://i.pravatar.cc/150?img=12',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '14:30',
      'status': 'Завершен',
      'statusColor': const Color(0xFFE8F5E9),
      'statusTextColor': AppColors.success,
    },
  ];

  List<Map<String, dynamic>> get todayAppointments {
    return allAppointments.where((appointment) {
      final appointmentDate = appointment['date'] as DateTime;
      return appointmentDate.year == selectedDate.year &&
          appointmentDate.month == selectedDate.month &&
          appointmentDate.day == selectedDate.day;
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Text(
                'Расписание приёмов',
                style: AppTextStyles.h2.copyWith(fontSize: 28),
              ),
            ),

            // Календарь
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => _showFullCalendar(),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                      // Месяц и год
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getMonthYearString(displayedMonth),
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 20,
                              color: AppColors.textWhite,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.textWhite,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Мини-календарь
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _buildMiniCalendar(),
                      ),
                    ],
                  ),
                ),
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
                    'Сегодняшние приёмы',
                    style: AppTextStyles.h3.copyWith(fontSize: 22),
                  ),
                  GestureDetector(
                    onTap: () => _showAllAppointments(),
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

            // Список приёмов
            Expanded(
              child: todayAppointments.isEmpty
                  ? Center(
                      child: Text(
                        'Нет приёмов на эту дату',
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: todayAppointments.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildAppointmentCard(
                            todayAppointments[index],
                          ),
                        );
                      },
                    ),
            ),

            // Кнопка добавления - ОБНОВЛЕНО
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Hero(
                  tag: 'add_appointment_button',
                  child: Material(
                    color: Colors.transparent,
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
                        onPressed: _openCreateAppointmentScreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // НОВЫЙ МЕТОД: Открытие креативного экрана создания
  void _openCreateAppointmentScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateAppointmentScreen(initialDate: selectedDate),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        allAppointments.add({
          'name': result['name'],
          'image':
              'https://i.pravatar.cc/150?img=${allAppointments.length + 1}',
          'date': result['date'],
          'time': result['time'],
          'status': result['status'],
          'statusColor': result['statusColor'],
          'statusTextColor': result['statusTextColor'],
        });
      });

      // Показываем успешное уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('Запись успешно создана!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Мини-календарь (неделя)
  Widget _buildMiniCalendar() {
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    final days = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Column(
      children: [
        // Дни недели
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final dayIndex = (selectedDate.weekday - 2 + index) % 7;
            return SizedBox(
              width: 60,
              child: Text(
                weekDays[dayIndex],
                style: AppTextStyles.body2.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Даты
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final day = selectedDate.add(Duration(days: index - 1));
            final isSelected =
                day.day == selectedDate.day &&
                day.month == selectedDate.month &&
                day.year == selectedDate.year;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = day;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    day.day.toString(),
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 20,
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Карточка приёма
  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
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
      child: Row(
        children: [
          // Аватар
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(appointment['image']),
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
                  appointment['name'],
                  style: AppTextStyles.h3.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getDateString(appointment['date'])}, ${appointment['time']}',
                  style: AppTextStyles.body2.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 8),
                // Статус
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: appointment['statusColor'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status'],
                    style: AppTextStyles.body2.copyWith(
                      fontSize: 12,
                      color: appointment['statusTextColor'],
                      fontWeight: FontWeight.w600,
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

  // Полный календарь
  void _showFullCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setModalState(() {
                          displayedMonth = DateTime(
                            displayedMonth.year,
                            displayedMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Text(
                      _getMonthYearString(displayedMonth),
                      style: AppTextStyles.h3.copyWith(fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setModalState(() {
                          displayedMonth = DateTime(
                            displayedMonth.year,
                            displayedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Календарь
              Expanded(child: _buildFullCalendarGrid(setModalState)),
            ],
          ),
        ),
      ),
    );
  }

  // Сетка полного календаря
  Widget _buildFullCalendarGrid(StateSetter setModalState) {
    final firstDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;

    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Дни недели
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: AppTextStyles.body2.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // Дни месяца
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: startWeekday - 1 + daysInMonth,
              itemBuilder: (context, index) {
                if (index < startWeekday - 1) {
                  return const SizedBox();
                }
                final day = index - startWeekday + 2;
                final date = DateTime(
                  displayedMonth.year,
                  displayedMonth.month,
                  day,
                );
                final isSelected =
                    date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final hasAppointments = allAppointments.any((apt) {
                  final aptDate = apt['date'] as DateTime;
                  return aptDate.year == date.year &&
                      aptDate.month == date.month &&
                      aptDate.day == date.day;
                });

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                    setModalState(() {});
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: hasAppointments && !isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: AppTextStyles.body1.copyWith(
                          fontSize: 14,
                          color: isSelected
                              ? AppColors.textWhite
                              : AppColors.textPrimary,
                          fontWeight: hasAppointments
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Все приёмы
  void _showAllAppointments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AllAppointmentsScreen(
          appointments: allAppointments,
          onDelete: (index) {
            setState(() {
              allAppointments.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getDateString(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Сегодня';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1) {
      return 'Завтра';
    }
    return '${date.day}.${date.month}.${date.year}';
  }
}

// Экран всех приёмов
class _AllAppointmentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(int) onDelete;

  const _AllAppointmentsScreen({
    required this.appointments,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
          'Все приёмы',
          style: AppTextStyles.h2.copyWith(fontSize: 24),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Dismissible(
              key: Key(appointment['name'] + index.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                onDelete(index);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Приём удалён')));
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
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
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(appointment['image']),
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
                            appointment['name'],
                            style: AppTextStyles.h3.copyWith(fontSize: 17),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_getDateString(appointment['date'])}, ${appointment['time']}',
                            style: AppTextStyles.body2.copyWith(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: appointment['statusColor'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              appointment['status'],
                              style: AppTextStyles.body2.copyWith(
                                fontSize: 12,
                                color: appointment['statusTextColor'],
                                fontWeight: FontWeight.w600,
                              ),
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
        },
      ),
    );
  }

  String _getDateString(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Сегодня';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day + 1) {
      return 'Завтра';
    }
    return '${date.day}.${date.month}.${date.year}';
  }
}
