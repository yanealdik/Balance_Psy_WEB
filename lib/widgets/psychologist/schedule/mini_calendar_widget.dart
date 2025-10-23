import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class MiniCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const MiniCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Column(
      children: [
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final day = selectedDate.add(Duration(days: index - 1));
            final isSelected =
                day.day == selectedDate.day &&
                day.month == selectedDate.month &&
                day.year == selectedDate.year;
            return GestureDetector(
              onTap: () => onDateSelected(day),
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
}
