// ════════════════════════════════════════════════════════════════════════
// lib/web_pages/profile_patient/profile_patient.dart
// ════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/profile_patient/patient_bar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../сore/router/app_router.dart';

class ProfilePatientPage extends StatefulWidget {
  const ProfilePatientPage({super.key});

  @override
  State<ProfilePatientPage> createState() => _ProfilePatientPageState();
}

class _ProfilePatientPageState extends State<ProfilePatientPage> {
  bool _isEditing = false;

  // Данные профиля
  String _name = 'Альдияр';
  String _email = 'aldiyar@example.com';
  String _phone = '+7 (777) 123-45-67';
  String _birthDate = '15 марта 1990';
  String _gender = 'Мужской';
  String _therapyGoals = 'Снижение тревожности, работа со стрессом';

  // Контроллеры для редактирования
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _therapyGoalsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController.text = _name;
    _emailController.text = _email;
    _phoneController.text = _phone;
    _birthDateController.text = _birthDate;
    _therapyGoalsController.text = _therapyGoals;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveChanges() {
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      _phone = _phoneController.text;
      _birthDate = _birthDateController.text;
      _therapyGoals = _therapyGoalsController.text;
      _isEditing = false;
    });

    // Здесь можно добавить сохранение данных на сервер
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _initializeControllers(); // Восстанавливаем оригинальные значения
    });
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
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage(
                  'assets/images/avatar/aldiyar.png',
                ),
                backgroundColor: AppColors.primary.withOpacity(0.1),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: IconButton(
                      onPressed: _changeAvatar,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_isEditing) ...[
                  Text(_name, style: AppTextStyles.h1.copyWith(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text(
                    _email,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ] else ...[
                  _buildEditableField(
                    controller: _nameController,
                    hintText: 'Имя',
                    style: AppTextStyles.h1.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  _buildEditableField(
                    controller: _emailController,
                    hintText: 'Email',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
          if (!_isEditing)
            IconButton(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.primary,
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  onPressed: _saveChanges,
                  icon: Icons.check,
                  color: AppColors.success,
                  tooltip: 'Сохранить',
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  onPressed: _cancelEditing,
                  icon: Icons.close,
                  color: Colors.red,
                  tooltip: 'Отменить',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 20, color: color),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hintText,
    required TextStyle style,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: style,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: style.copyWith(color: AppColors.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Личная информация', style: AppTextStyles.h2),
              if (_isEditing)
                Text(
                  'Режим редактирования',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Телефон', _phone, _phoneController, Icons.phone),
          _buildInfoRow(
            'Дата рождения',
            _birthDate,
            _birthDateController,
            Icons.calendar_today,
          ),
          _buildGenderRow(),
          _buildInfoRow(
            'Цели терапии',
            _therapyGoals,
            _therapyGoalsController,
            Icons.flag,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isEditing
                ? _buildEditableInfoField(controller, label)
                : Text(
                    value,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableInfoField(
    TextEditingController controller,
    String label,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        maxLines: label == 'Цели терапии' ? 3 : 1,
        decoration: InputDecoration(
          hintText: 'Введите $label',
          hintStyle: AppTextStyles.body1.copyWith(
            color: AppColors.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Пол',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isEditing
                ? _buildGenderSelector()
                : Text(
                    _gender,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _buildGenderOption('Мужской', Icons.male),
        const SizedBox(width: 16),
        _buildGenderOption('Женский', Icons.female),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _gender == gender;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _gender = gender;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.inputBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.inputBorder,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  gender,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileActions(BuildContext ctx) {
    final actions = [
      _ProfileAction(
        icon: Icons.person_outline,
        title: 'Личные данные',
        onTap: _startEditing,
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

  void _changeAvatar() {
    // Здесь можно добавить логику для смены аватара
    _showComingSoon(context, 'Смена аватара');
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _therapyGoalsController.dispose();
    super.dispose();
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
