import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет карточки пациента
class PatientCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int sessionCount;
  final String lastTheme;
  final VoidCallback onTap;

  const PatientCardWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.sessionCount,
    required this.lastTheme,
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
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
                  Text(name, style: AppTextStyles.h3.copyWith(fontSize: 17)),
                  const SizedBox(height: 4),
                  Text(
                    '$sessionCount ${_getSessionWord(sessionCount)} • $lastTheme',
                    style: AppTextStyles.body2.copyWith(fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _getSessionWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'сеанс';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'сеанса';
    } else {
      return 'сеансов';
    }
  }
}
