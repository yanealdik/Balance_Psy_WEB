import 'package:flutter/material.dart';

// Конфигурации navbar для разных ролей
class NavConfig {
  static const userIcons = [
    Icons.home_outlined,
    Icons.psychology_outlined,
    Icons.article_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  static const psychologistIcons = [
    Icons.home_outlined,
    Icons.calendar_today_outlined,
    Icons.analytics_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];
}

// Универсальный NavBar
class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<IconData> icons;
  final Color? selectedColor;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(icons.length, (i) {
            final isSelected = currentIndex == i;
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? Colors.blue[400])
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: (selectedColor ?? Colors.blue).withOpacity(
                              0.25,
                            ),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ]
                      : [],
                ),
                child: Icon(icons[i], size: 28, color: Colors.black),
              ),
            );
          }),
        ),
      ),
    );
  }
}
