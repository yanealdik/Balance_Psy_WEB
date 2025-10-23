import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

void showFullCalendarModal({
  required BuildContext context,
  required DateTime selectedDate,
  required DateTime displayedMonth,
  required List<Map<String, dynamic>> allAppointments,
  required Function(DateTime) onDateSelected,
  required Function(DateTime) onMonthChanged,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        DateTime currentMonth = displayedMonth;

        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month - 1,
                        );
                        setModalState(() {});
                        onMonthChanged(currentMonth);
                      },
                    ),
                    Text(
                      _getMonthYearString(currentMonth),
                      style: AppTextStyles.h3.copyWith(fontSize: 20),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month + 1,
                        );
                        setModalState(() {});
                        onMonthChanged(currentMonth);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildFullCalendarGrid(
                  context: context,
                  selectedDate: selectedDate,
                  displayedMonth: currentMonth,
                  allAppointments: allAppointments,
                  onDateSelected: onDateSelected,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildFullCalendarGrid({
  required BuildContext context,
  required DateTime selectedDate,
  required DateTime displayedMonth,
  required List<Map<String, dynamic>> allAppointments,
  required Function(DateTime) onDateSelected,
}) {
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
              if (index < startWeekday - 1) return const SizedBox();

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
                  onDateSelected(date);
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
