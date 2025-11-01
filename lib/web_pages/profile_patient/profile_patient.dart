// ════════════════════════════════════════════════════════════════════════
// lib/web_pages/profile_patient/profile_patient.dart
// ════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../widgets/profile_patient/patient_bar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class ProfilePatientPage extends StatelessWidget {
  const ProfilePatientPage({super.key});

  @override
  Widget build(BuildContext ctx) {
    return PageWrapper(
      currentRoute: AppRouter.profile,
      showHeader: false,
      showFooter: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Боковое меню - используем виджет
          PatientBar(currentRoute: AppRouter.profile),
          
          // Основной контент профиля
          Expanded(
            child: SingleChildScrollView(
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
            ),
          ),
        ],
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
          CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage('assets/images/avatar/aldiyar.png'),
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Альдияр', style: AppTextStyles.h1.copyWith(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  'aldiyar@example.com',
                  style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildProfileStat('Сессии', '12'),
                    const SizedBox(width: 20),
                    _buildProfileStat('Статьи', '8'),
                    const SizedBox(width: 20),
                    _buildProfileStat('Недели', '6'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showComingSoon(ctx, 'Редактирование профиля'),
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
          _buildInfoRow('Телефон', '+7 (777) 123-45-67'),
          _buildInfoRow('Дата рождения', '15 марта 1990'),
          _buildInfoRow('Пол', 'Мужской'),
          _buildInfoRow('Цели терапии', 'Снижение тревожности, работа со стрессом'),
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

  Widget _buildProfileActions(BuildContext ctx) {
    final actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        title: 'Личные данные',
        onTap: () => _showComingSoon(ctx, 'Личные данные'),
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
        onTap: () => _showComingSoon(ctx, 'Настройки'),
      ),
      _ProfileAction(
        icon: Icons.logout,
        title: 'Выйти',
        color: Colors.red,
        onTap: () => _showComingSoon(ctx, 'Выход'),
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
        children: actions.map((action) => _buildProfileActionTile(action)).toList(),
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
              Icon(action.icon, color: action.color ?? AppColors.primary, size: 24),
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

  void _showComingSoon(BuildContext ctx, String feature) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('$feature - скоро будет доступно'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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