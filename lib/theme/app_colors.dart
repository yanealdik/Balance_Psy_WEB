import 'package:flutter/material.dart';

/// Цветовая палитра приложения BalancePsy
class AppColors {
  // Основные цвета
  static const Color primary = Color(0xFF57A2EB); // Основной голубой
  static const Color primaryLight = Color(0xFF8BC9F0); // Светло-голубой
  static const Color primaryDark = Color(0xFF3D8DD6); // Темно-голубой

  // Фоновые цвета
  static const Color background = Color(0xFFFFFFFF); // Белый фон
  static const Color backgroundLight = Color(0xFFF5F9FC); // Светлый фон
  static const Color cardBackground = Color(0xFFFFFFFF); // Фон карточек

  // Текстовые цвета
  static const Color textPrimary = Color(0xFF1E3558); // Основной текст (черный)
  static const Color textSecondary = Color(
    0xFF4A5B70,
  ); // Вторичный текст (серый)
  static const Color textTertiary = Color(
    0xFF9CA3AF,
  ); // Третичный текст (светло-серый)
  static const Color textWhite = Color(0xFFFFFFFF); // Белый текст

  // Цвета для элементов
  static const Color inputBackground = Color(0xFFEFF6FB); // Фон полей ввода
  static const Color inputBorder = Color(0xFF5BA4E3); // Граница полей
  static const Color success = Color(0xFF10B981); // Зеленый для галочки
  static const Color error = Color(0xFFF97316); // Оранжевый для ошибок
  static const Color warning = Color(0xFFFBBF24); // Желтый для предупреждений

  // Специальные цвета
  static const Color illustrationBlue = Color(0xFF5BA4E3); // Цвет иллюстраций
  static const Color shadow = Color(0x1A000000); // Тень (10% прозрачности)
}
