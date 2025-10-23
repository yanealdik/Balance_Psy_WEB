import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class MoodTracker extends StatelessWidget {
  final Function(String) onMoodSelected;

  const MoodTracker({super.key, required this.onMoodSelected});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {
        'image': 'assets/images/mood/mood_overjoyed.png',
        'label': 'Отлично',
        'color': const Color(0xFF4CAF50),
      },
      {
        'image': 'assets/images/mood/mood_happy.png',
        'label': 'Хорошо',
        'color': const Color(0xFF8BC34A),
      },
      {
        'image': 'assets/images/mood/mood_neutral.png',
        'label': 'Норм',
        'color': const Color(0xFFFFC107),
      },
      {
        'image': 'assets/images/mood/mood_sad.png',
        'label': 'Грустно',
        'color': const Color(0xFFFF9800),
      },
      {
        'image': 'assets/images/mood/mood_depressed.png',
        'label': 'Плохо',
        'color': const Color(0xFFF44336),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Как твоё настроение сейчас?',
            style: AppTextStyles.body1.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((mood) {
              return GestureDetector(
                onTap: () => onMoodSelected(mood['label'] as String),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (mood['color'] as Color).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: mood['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              mood['image'] as String,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.white,
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mood['label'] as String,
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
