import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../models/user_register_model.dart';

class Step3Birthdate extends StatefulWidget {
  final UserRegisterModel userData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step3Birthdate({
    super.key,
    required this.userData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step3Birthdate> createState() => _Step3BirthdateState();
}

class _Step3BirthdateState extends State<Step3Birthdate> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.userData.birthDate;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.userData.birthDate = picked;

        // Проверка возраста
        final age = widget.userData.getAge();
        widget.userData.isMinor = (age != null && age < 18);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 24 : 60),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isMobile),
              SizedBox(height: isMobile ? 32 : 48),
              _buildDateSelector(isMobile),
              if (_selectedDate != null) ...[
                SizedBox(height: isMobile ? 24 : 32),
                _buildAgeInfo(isMobile),
              ],
              if (widget.userData.isMinor) ...[
                SizedBox(height: isMobile ? 24 : 32),
                _buildMinorWarning(isMobile),
              ],
              SizedBox(height: isMobile ? 32 : 48),
              _buildButtons(isMobile),
            ],
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
          'Дата рождения',
          style: isMobile ? AppTextStyles.h2 : AppTextStyles.h1,
        ),
        const SizedBox(height: 8),
        Text(
          'Эта информация поможет подобрать подходящего специалиста',
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDateSelector(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите дату',
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedDate != null
                    ? AppColors.primary
                    : AppColors.inputBorder,
                width: _selectedDate != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedDate != null
                            ? _formatDate(_selectedDate!)
                            : 'Выберите дату рождения',
                        style: _selectedDate != null
                            ? AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )
                            : AppTextStyles.inputHint.copyWith(fontSize: 18),
                      ),
                      if (_selectedDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Возраст: ${widget.userData.getAge()} лет',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeInfo(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Отлично! Ваш возраст позволяет пользоваться всеми функциями платформы',
              style: AppTextStyles.body2.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinorWarning(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warning, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Требуется согласие родителя',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Вам меньше 18 лет. Для использования платформы потребуется подтверждение от родителя или законного представителя. Мы отправим запрос на email, который вы укажете на следующем шаге.',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(bool isMobile) {
    return Row(
      children: [
        if (!isMobile) ...[
          SizedBox(
            width: 140,
            height: 56,
            child: CustomButton(
              text: 'Назад',
              onPressed: widget.onBack,
              isPrimary: false,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: 16),
        ],
        SizedBox(
          width: isMobile ? double.infinity : 220,
          height: 56,
          child: CustomButton(
            text: 'Продолжить',
            onPressed: _selectedDate != null ? widget.onNext : null,
            isPrimary: true,
            isFullWidth: true,
            showArrow: true,
          ),
        ),
      ],
    );
  }
}
