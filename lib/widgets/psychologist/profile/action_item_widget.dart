import 'package:flutter/material.dart';
import '../../../theme/app_text_styles.dart';

/// Виджет элемента действия (для настроек/профиля)
class ActionItemWidget extends StatelessWidget {
  final String title;
  final Widget trailing;

  const ActionItemWidget({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.body1.copyWith(fontSize: 16)),
          trailing,
        ],
      ),
    );
  }
}
