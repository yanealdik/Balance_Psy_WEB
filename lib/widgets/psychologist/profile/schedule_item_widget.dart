import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет элемента расписания
class ScheduleItemWidget extends StatelessWidget {
  final String time;
  final String clientName;
  final String status; // 'upcoming', 'free', 'completed'

  const ScheduleItemWidget({
    super.key,
    required this.time,
    required this.clientName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'free'
        ? AppColors.textSecondary
        : status == 'completed'
        ? AppColors.success
        : AppColors.primary;

    IconData statusIcon = status == 'free'
        ? Icons.add_circle_outline
        : status == 'completed'
        ? Icons.check_circle_outline
        : Icons.videocam_outlined;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  clientName,
                  style: AppTextStyles.body2.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(statusIcon, color: statusColor, size: 20),
        ],
      ),
    );
  }
}
