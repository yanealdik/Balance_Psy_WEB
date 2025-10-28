import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../models/user_register_model.dart';

class Step1UserInfo extends StatefulWidget {
  final UserRegisterModel userData;
  final VoidCallback onNext;

  const Step1UserInfo({
    super.key,
    required this.userData,
    required this.onNext,
  });

  @override
  State<Step1UserInfo> createState() => _Step1UserInfoState();
}

class _Step1UserInfoState extends State<Step1UserInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGender;

  final List<PurposeOption> _purposes = [
    PurposeOption(
      title: 'Справиться с тревогой',
      icon: Icons.psychology_outlined,
      color: AppColors.primary,
    ),
    PurposeOption(
      title: 'Улучшить отношения',
      icon: Icons.favorite_border,
      color: Color(0xFFE91E63),
    ),
    PurposeOption(
      title: 'Разобраться в себе',
      icon: Icons.self_improvement_outlined,
      color: Color(0xFF9C27B0),
    ),
    PurposeOption(
      title: 'Пережить кризис',
      icon: Icons.crisis_alert_outlined,
      color: Color(0xFFFF9800),
    ),
    PurposeOption(
      title: 'Повысить самооценку',
      icon: Icons.emoji_emotions_outlined,
      color: Color(0xFF4CAF50),
    ),
    PurposeOption(
      title: 'Найти смысл жизни',
      icon: Icons.explore_outlined,
      color: Color(0xFF00BCD4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.name ?? '';
    _selectedGender = widget.userData.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.isNotEmpty &&
      _selectedGender != null &&
      widget.userData.purposes.isNotEmpty;

  void _handleNext() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.userData.name = _nameController.text;
      widget.userData.gender = _selectedGender;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 24 : 60),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildNameField(isMobile),
                SizedBox(height: isMobile ? 24 : 32),
                _buildGenderSelection(isMobile),
                SizedBox(height: isMobile ? 24 : 32),
                _buildPurposesSection(isMobile),
                SizedBox(height: isMobile ? 32 : 48),
                _buildNextButton(isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Расскажите о себе',
          style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
        ),
        const SizedBox(height: 8),
        Text(
          'Эта информация поможет нам подобрать подходящих специалистов',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildNameField(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ваше имя',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: 'Введите имя',
            hintStyle: AppTextStyles.inputHint,
            filled: true,
            fillColor: AppColors.inputBackground,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Пожалуйста, введите ваше имя';
            }
            if (value.length < 2) {
              return 'Имя должно содержать минимум 2 символа';
            }
            return null;
          },
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildGenderSelection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Пол',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderButton(
                'Мужской',
                'male',
                Icons.male,
                isMobile,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderButton(
                'Женский',
                'female',
                Icons.female,
                isMobile,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(
    String label,
    String value,
    IconData icon,
    bool isMobile,
  ) {
    final isSelected = _selectedGender == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isMobile ? 14 : 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposesSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Что привело вас к нам?',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Выберите одну или несколько целей',
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _purposes.map((purpose) {
            final isSelected = widget.userData.purposes.contains(purpose.title);

            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    widget.userData.purposes.remove(purpose.title);
                  } else {
                    widget.userData.purposes.add(purpose.title);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 16,
                  vertical: isMobile ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? purpose.color.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? purpose.color : AppColors.inputBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : purpose.icon,
                      color: isSelected
                          ? purpose.color
                          : AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      purpose.title,
                      style: AppTextStyles.body2.copyWith(
                        color: isSelected
                            ? purpose.color
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNextButton(bool isMobile) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: isMobile ? double.infinity : 240,
        height: 56,
        child: CustomButton(
          text: 'Продолжить',
          onPressed: _canContinue ? _handleNext : null,
          isPrimary: true,
          isFullWidth: true,
          showArrow: true,
        ),
      ),
    );
  }
}

class PurposeOption {
  final String title;
  final IconData icon;
  final Color color;

  PurposeOption({required this.title, required this.icon, required this.color});
}
