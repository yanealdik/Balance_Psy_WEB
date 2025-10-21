import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Экран настроек приложения
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool darkModeEnabled = false;
  String selectedLanguage = 'Русский';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Настройки',
          style: AppTextStyles.h2.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Секция: Уведомления
            _buildSection(
              title: 'Уведомления',
              children: [
                _buildSwitchItem(
                  title: 'Включить уведомления',
                  subtitle: 'Получать push-уведомления',
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchItem(
                  title: 'Звук уведомлений',
                  subtitle: 'Воспроизводить звуки',
                  value: soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      soundEnabled = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildSwitchItem(
                  title: 'Вибрация',
                  subtitle: 'Вибрировать при уведомлениях',
                  value: vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      vibrationEnabled = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Секция: Внешний вид
            _buildSection(
              title: 'Внешний вид',
              children: [
                _buildSwitchItem(
                  title: 'Темная тема',
                  subtitle: 'Использовать темное оформление',
                  value: darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      darkModeEnabled = value;
                    });
                  },
                ),
                _buildDivider(),
                _buildNavigationItem(
                  title: 'Язык приложения',
                  subtitle: selectedLanguage,
                  onTap: () {
                    _showLanguageDialog();
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Секция: Конфиденциальность
            _buildSection(
              title: 'Конфиденциальность',
              children: [
                _buildNavigationItem(
                  title: 'Политика конфиденциальности',
                  subtitle: 'Как мы обрабатываем ваши данные',
                  onTap: () {
                    // TODO: Открыть политику конфиденциальности
                  },
                ),
                _buildDivider(),
                _buildNavigationItem(
                  title: 'Условия использования',
                  subtitle: 'Правила и условия',
                  onTap: () {
                    // TODO: Открыть условия использования
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Секция: Учетная запись
            _buildSection(
              title: 'Учетная запись',
              children: [
                _buildNavigationItem(
                  title: 'Изменить пароль',
                  subtitle: 'Обновить пароль входа',
                  onTap: () {
                    // TODO: Изменить пароль
                  },
                ),
                _buildDivider(),
                _buildNavigationItem(
                  title: 'Удалить аккаунт',
                  subtitle: 'Безвозвратное удаление данных',
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                  titleColor: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Секция: Поддержка
            _buildSection(
              title: 'Поддержка',
              children: [
                _buildNavigationItem(
                  title: 'Помощь и поддержка',
                  subtitle: 'Связаться с нами',
                  onTap: () {
                    // TODO: Открыть поддержку
                  },
                ),
                _buildDivider(),
                _buildNavigationItem(
                  title: 'О приложении',
                  subtitle: 'Версия 1.0.0',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Секция настроек
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                title,
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  // Элемент с переключателем
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body1.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Элемент с навигацией
  Widget _buildNavigationItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 16,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.body2.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // Разделитель
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(color: AppColors.inputBorder.withOpacity(0.3), height: 1),
    );
  }

  // Диалог выбора языка
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Выберите язык',
          style: AppTextStyles.h3.copyWith(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Русский'),
            //_buildLanguageOption('Қазақша'),
            //_buildLanguageOption('English'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = selectedLanguage == language;
    return ListTile(
      title: Text(
        language,
        style: AppTextStyles.body1.copyWith(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  // Диалог удаления аккаунта
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Удалить аккаунт?',
          style: AppTextStyles.h3.copyWith(fontSize: 20),
        ),
        content: Text(
          'Вы действительно хотите удалить свой аккаунт? Это действие необратимо.',
          style: AppTextStyles.body1.copyWith(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: AppTextStyles.body1.copyWith(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Удалить аккаунт
            },
            child: Text(
              'Удалить',
              style: AppTextStyles.body1.copyWith(
                fontSize: 15,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Диалог о приложении
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'О приложении',
          style: AppTextStyles.h3.copyWith(fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BalancePsy',
              style: AppTextStyles.h3.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Версия 1.0.0',
              style: AppTextStyles.body2.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Платформа для психологической поддержки и консультаций с профессиональными психологами.',
              style: AppTextStyles.body1.copyWith(fontSize: 15),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Закрыть',
              style: AppTextStyles.body1.copyWith(
                fontSize: 15,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
