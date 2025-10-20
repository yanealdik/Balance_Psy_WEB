import 'package:balance_psy/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../setting/setting_screen.dart';

/// Экран профиля пользователя - Новый скриншот 4
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Верхняя панель
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Мой профиль',
                      style: AppTextStyles.h2.copyWith(fontSize: 28),
                    ),
                    // Кнопка настроек
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Аватар и имя
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?img=60'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 3,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Имя пользователя
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'АЛДИЯР БАЙДІЛДА',
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                'Пациент BalancePsy',
                style: AppTextStyles.body2.copyWith(fontSize: 14),
              ),

              const SizedBox(height: 24),

              // Кнопка редактирования профиля
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: 'Редактировать профиль',
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ),

              const SizedBox(height: 24),

              // Мои рекомендации
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мои рекомендации',
                        style: AppTextStyles.h3.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      _buildRecommendationItem(
                        icon: Icons.bedtime,
                        text: 'Попробуйте 5-минутную медитацию перед сном.',
                      ),
                      const SizedBox(height: 12),
                      _buildRecommendationItem(
                        icon: Icons.article_outlined,
                        text: 'Прочитайте статью: Как говорить о чувствах',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Действия
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Действия',
                        style: AppTextStyles.h3.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      _buildActionItem(
                        title: 'Уведомления',
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              notificationsEnabled = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _buildDivider(),
                      _buildActionItem(
                        title: 'Темная тема',
                        trailing: Switch(
                          value: darkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              darkModeEnabled = value;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),
                      _buildDivider(),
                      GestureDetector(
                        onTap: () {
                          // TODO: Открыть помощь и поддержку
                        },
                        child: _buildActionItem(
                          title: 'Помощь и поддержка',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Кнопка выхода
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(28),
                      child: Center(
                        child: Text(
                          'Выйти из Аккаунта',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Элемент рекомендации
  Widget _buildRecommendationItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: AppTextStyles.body1.copyWith(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // Элемент действия
  Widget _buildActionItem({required String title, required Widget trailing}) {
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

  // Разделитель
  Widget _buildDivider() {
    return Divider(color: AppColors.inputBorder.withOpacity(0.3), height: 1);
  }
}
