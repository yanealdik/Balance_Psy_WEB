import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotificationsTap;
  final String formattedDate;
  final bool hasUnreadNotifications;

  const HomeTopBar({
    super.key,
    required this.onAvatarTap,
    required this.onCalendarTap,
    required this.onNotificationsTap,
    required this.formattedDate,
    this.hasUnreadNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: 'user_avatar',
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?img=60'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onCalendarTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    formattedDate,
                    style: AppTextStyles.h3.copyWith(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  onPressed: onNotificationsTap,
                ),
              ),
              if (hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
