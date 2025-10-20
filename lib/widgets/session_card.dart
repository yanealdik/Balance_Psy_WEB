import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

/// Переиспользуемая карточка сессии
class SessionCard extends StatelessWidget {
  final String psychologistName;
  final String psychologistImage;
  final String dateTime;
  final String status;
  final Color statusColor;
  final VoidCallback? onVideoTap;
  final VoidCallback? onChatTap;
  final bool showActions;

  const SessionCard({
    Key? key,
    required this.psychologistName,
    required this.psychologistImage,
    required this.dateTime,
    required this.status,
    this.statusColor = const Color(0xFFD4A747),
    this.onVideoTap,
    this.onChatTap,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Аватар психолога
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  image: DecorationImage(
                    image: NetworkImage(psychologistImage),
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
                      psychologistName,
                      style: AppTextStyles.h3.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateTime,
                          style: AppTextStyles.body2.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Статус
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.body2.copyWith(
                          fontSize: 11,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showActions) ...[
            const SizedBox(height: 16),

            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onVideoTap,
                    icon: const Icon(Icons.videocam_outlined, size: 20),
                    label: const Text('Видео'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Чат',
                    onPressed: onChatTap ?? () {},
                    icon: Icons.chat_bubble_outline,
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
