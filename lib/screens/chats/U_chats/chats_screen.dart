import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../Message/Message_screen.dart';

/// Экран чатов с психологами - Новый скриншот 3
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Галия Аубакирова',
        'status': 'онлайн',
        'statusColor': AppColors.success,
        'image': 'assets/images/avatar/Galiya.png',
      },
      {
        'name': 'Яна Прозорова',
        'status': 'не в сети',
        'statusColor': AppColors.textTertiary,
        'image': 'https://i.pravatar.cc/150?img=10',
      },
      {
        'name': 'Лаура Болдина',
        'status': 'занята',
        'statusColor': AppColors.error,
        'image': 'https://i.pravatar.cc/150?img=9',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                'Чаты',
                style: AppTextStyles.h2.copyWith(fontSize: 28),
              ),
            ),

            // Подзаголовок
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Мои психологи',
                style: AppTextStyles.h3.copyWith(fontSize: 22),
              ),
            ),

            // Список чатов
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildChatItem(context, chats[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Элемент чата
  Widget _buildChatItem(BuildContext context, Map<String, dynamic> chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              psychologistName: chat['name'],
              psychologistImage: chat['image'],
              psychologistStatus: chat['status'],
            ),
          ),
        );
      },
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
            // Аватар
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
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
                // Индикатор статуса
                if (chat['status'] == 'онлайн')
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chat['statusColor'],
                        border: Border.all(
                          color: AppColors.cardBackground,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'],
                    style: AppTextStyles.h3.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: chat['statusColor'],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        chat['status'],
                        style: AppTextStyles.body2.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Кнопка чата
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
