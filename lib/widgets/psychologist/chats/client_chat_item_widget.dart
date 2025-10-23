import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет элемента чата с клиентом
class ClientChatItemWidget extends StatelessWidget {
  final Map<String, dynamic> chat;
  final VoidCallback onTap;

  const ClientChatItemWidget({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: chat['hasUnread']
              ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: chat['hasUnread']
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.shadow,
              blurRadius: chat['hasUnread'] ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Аватар клиента
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: chat['image'].startsWith('http')
                          ? NetworkImage(chat['image'])
                          : AssetImage(chat['image']) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Индикатор онлайн
                if (chat['isOnline'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        border: Border.all(
                          color: AppColors.cardBackground,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // Информация о чате
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat['name'],
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            fontWeight: chat['hasUnread']
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat['time'],
                        style: AppTextStyles.body2.copyWith(
                          fontSize: 12,
                          color: chat['hasUnread']
                              ? AppColors.primary
                              : AppColors.textTertiary,
                          fontWeight: chat['hasUnread']
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat['lastMessage'],
                          style: AppTextStyles.body2.copyWith(
                            fontSize: 14,
                            color: chat['hasUnread']
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            fontWeight: chat['hasUnread']
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat['unreadCount'] > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${chat['unreadCount']}',
                              style: AppTextStyles.body2.copyWith(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
