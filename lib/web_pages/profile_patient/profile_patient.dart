// lib/web_pages/profile_patient/profile_patient.dart

import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../widgets/profile_patient/patient_bar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';
import '../../services/user_service.dart';
import '../../services/api_service.dart';
import '../../models/user_model.dart';

class ProfilePatientPage extends StatefulWidget {
  const ProfilePatientPage({super.key});

  @override
  State<ProfilePatientPage> createState() => _ProfilePatientPageState();
}

class _ProfilePatientPageState extends State<ProfilePatientPage> {
  UserModel? _user;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await UserService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки профиля: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return PageWrapper(
      currentRoute: AppRouter.profile,
      showHeader: false,
      showFooter: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PatientBar(currentRoute: AppRouter.profile),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _errorMessage != null
                ? _buildErrorState()
                : _buildProfileContent(ctx),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Загрузка профиля...', style: AppTextStyles.body1),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: AppTextStyles.body1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadUserData,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext ctx) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        margin: const EdgeInsets.all(40),
        child: Column(
          children: [
            _buildProfileHeader(ctx),
            const SizedBox(height: 32),
            _buildProfileInfo(),
            const SizedBox(height: 32),
            _buildProfileActions(ctx),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Аватар
          _user?.avatarUrl != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_user!.avatarUrl!),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    _user?.fullName[0].toUpperCase() ?? 'A',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontSize: 36,
                    ),
                  ),
                ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.fullName ?? 'Имя не указано',
                  style: AppTextStyles.h1.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 8),
                Text(
                  _user?.email ?? '',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildProfileStat(
                      'Сессии',
                      '12',
                    ), // TODO: подключить реальные данные
                    const SizedBox(width: 20),
                    _buildProfileStat('Статьи', '8'),
                    const SizedBox(width: 20),
                    _buildProfileStat('Возраст', _user?.age?.toString() ?? '—'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(ctx, '/edit-profile');
              if (result == true) {
                _loadUserData(); // Перезагрузить данные после редактирования
              }
            },
            icon: const Icon(Icons.edit_outlined),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Личная информация', style: AppTextStyles.h2),
          const SizedBox(height: 24),
          _buildInfoRow('Телефон', _user?.phone ?? 'Не указан'),
          _buildInfoRow(
            'Дата рождения',
            _user?.dateOfBirth != null
                ? _formatDate(_user!.dateOfBirth!)
                : 'Не указана',
          ),
          _buildInfoRow(
            'Пол',
            _user?.gender != null
                ? (_user!.gender == 'male' ? 'Мужской' : 'Женский')
                : 'Не указан',
          ),
          _buildInfoRow(
            'Цели терапии',
            _user?.registrationGoal ?? 'Не указаны',
          ),
          if (_user?.interests != null && _user!.interests.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInterests(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Интересы',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _user!.interests.map((interest) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                interest,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProfileActions(BuildContext ctx) {
    final actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        title: 'Редактировать профиль',
        onTap: () async {
          final result = await Navigator.pushNamed(ctx, '/edit-profile');
          if (result == true) {
            _loadUserData();
          }
        },
      ),
      _ProfileAction(
        icon: Icons.event_available,
        title: 'Мои сессии',
        onTap: () => _showComingSoon(ctx, 'Мои сессии'),
      ),
      _ProfileAction(
        icon: Icons.credit_card,
        title: 'Оплата и подписка',
        onTap: () => _showComingSoon(ctx, 'Оплата и подписка'),
      ),
      _ProfileAction(
        icon: Icons.settings_outlined,
        title: 'Настройки',
        onTap: () => Navigator.pushNamed(ctx, '/settings'),
      ),
      _ProfileAction(
        icon: Icons.logout,
        title: 'Выйти',
        color: Colors.red,
        onTap: () => _showLogoutDialog(ctx),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: actions
            .map((action) => _buildProfileActionTile(action))
            .toList(),
      ),
    );
  }

  Widget _buildProfileActionTile(_ProfileAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.inputBorder.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                action.icon,
                color: action.color ?? AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action.title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: action.color ?? AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: action.color ?? AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Выход', style: AppTextStyles.h2),
        content: Text(
          'Вы уверены, что хотите выйти из аккаунта?',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена', style: AppTextStyles.body1),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.logout();
              if (ctx.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  ctx,
                  '/login',
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Выйти', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext ctx, String feature) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$feature - скоро будет доступно'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _ProfileAction {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });
}
