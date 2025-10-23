import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentCardWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
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
