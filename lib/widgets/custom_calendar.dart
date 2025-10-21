import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Переиспользуемый виджет календаря
class CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<DateTime>? highlightedDates; // Даты с событиями
  final bool showFullMonth; // Показать весь месяц или только неделю

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.highlightedDates,
    this.showFullMonth = false,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime displayedMonth;

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return widget.showFullMonth ? _buildFullCalendar() : _buildWeekCalendar();
  }

  // Календарь на неделю (компактный)
  Widget _buildWeekCalendar() {
    final startOfWeek = widget.selectedDate.subtract(
      Duration(days: widget.selectedDate.weekday - 1),
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
          children: List.generate(7, (index) {
            return SizedBox(
              width: 40,
              child: Text(
                weekDays[index],
                style: AppTextStyles.body2.copyWith(
                  fontSize: 12,
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
          children: List.generate(7, (index) {
            final day = days[index];
            final isSelected = _isSameDay(day, widget.selectedDate);
            final isHighlighted = _isHighlighted(day);
            final isToday = _isSameDay(day, DateTime.now());

            return GestureDetector(
              onTap: () => widget.onDateSelected(day),
              child: Container(
                width: 40,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isToday
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isHighlighted && !isSelected
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.day.toString(),
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 16,
                        fontWeight: isHighlighted
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textWhite
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (isHighlighted && !isSelected)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Полный календарь (месяц)
  Widget _buildFullCalendar() {
    return Column(
      children: [
        // Навигация по месяцам
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    displayedMonth = DateTime(
                      displayedMonth.year,
                      displayedMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                _getMonthYearString(displayedMonth),
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
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
        _buildCalendarGrid(),
      ],
    );
  }

  // Сетка календаря
  Widget _buildCalendarGrid() {
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
              final isSelected = _isSameDay(date, widget.selectedDate);
              final isHighlighted = _isHighlighted(date);
              final isToday = _isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: isHighlighted && !isSelected
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
                        fontWeight: isHighlighted
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isHighlighted(DateTime date) {
    if (widget.highlightedDates == null) return false;
    return widget.highlightedDates!.any((d) => _isSameDay(d, date));
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
}

/// Виджет с компактным календарем в карточке
class CompactCalendarCard extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onExpand;
  final List<DateTime>? highlightedDates;

  const CompactCalendarCard({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onExpand,
    this.highlightedDates,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExpand,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary.withOpacity(0.85), AppColors.primary],
          ),
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
                  _getMonthYearString(selectedDate),
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
            // Календарь
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomCalendar(
                selectedDate: selectedDate,
                onDateSelected: onDateSelected,
                highlightedDates: highlightedDates,
                showFullMonth: false,
              ),
            ),
          ],
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
}
