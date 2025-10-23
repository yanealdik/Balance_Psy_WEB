import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/psychologist/schedule/calendar_header.dart';
import '../../widgets/psychologist/schedule/mini_calendar_widget.dart';
import '../../widgets/psychologist/schedule/appointment_card_widget.dart';
import '../../widgets/psychologist/schedule/full_calendar_modal.dart';
import 'Appointment/appointment.dart';

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
                    'Расписание приёмов',
                    style: AppTextStyles.h2.copyWith(fontSize: 28),
                  ),
                ),

                // Календарь
                CalendarHeader(
                  displayedMonth: displayedMonth,
                  onTap: _showFullCalendar,
                  child: MiniCalendarWidget(
                    selectedDate: selectedDate,
                    onDateSelected: (date) =>
                        setState(() => selectedDate = date),
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
                        onTap: _showAllAppointments,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: AppColors.textTertiary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Нет приёмов на эту дату',
                                style: AppTextStyles.body1.copyWith(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: todayAppointments.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: AppointmentCardWidget(
                                appointment: todayAppointments[index],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          // Плавающая кнопка добавления
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _openCreateAppointmentScreen,
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

  void _openCreateAppointmentScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAppointmentScreen(
          initialDate: selectedDate,
          onAppointmentCreated: (appointment) {
            setState(() {
              allAppointments.add(appointment);
            });
          },
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
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

  void _showFullCalendar() {
    showFullCalendarModal(
      context: context,
      selectedDate: selectedDate,
      displayedMonth: displayedMonth,
      allAppointments: allAppointments,
      onDateSelected: (date) {
        setState(() => selectedDate = date);
      },
      onMonthChanged: (month) {
        setState(() => displayedMonth = month);
      },
    );
  }

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
}

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
              child: AppointmentCardWidget(appointment: appointment),
            ),
          );
        },
      ),
    );
  }
}
