import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';
import '../../../сore/router/app_router.dart';

class AboutStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AboutStep({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AboutStep> createState() => _AboutStepState();
}

class _AboutStepState extends State<AboutStep> {
  final _nameController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data['name'] ?? '';
    _selectedGender = widget.data['gender'];
    _selectedDate = widget.data['birthDate'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.isNotEmpty &&
      _selectedGender != null &&
      _selectedDate != null;

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.data['birthDate'] = picked;

        // Проверка возраста
        final age = DateTime.now().difference(picked).inDays ~/ 365;
        widget.data['isMinor'] = age < 18;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Расскажите о себе', style: AppTextStyles.h1),
          const SizedBox(height: 12),
          Text(
            'Это поможет нам подобрать подходящего специалиста',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ваше имя', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      hintText: 'Введите имя',
                      hintStyle: AppTextStyles.inputHint,
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.data['name'] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  Text('Пол', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildGenderButton('Мужской', 'male')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildGenderButton('Женский', 'female')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Дата рождения', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.inputBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate != null
                                ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
                                : 'Выберите дату',
                            style: _selectedDate != null
                                ? AppTextStyles.input
                                : AppTextStyles.inputHint,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.data['isMinor'] == true) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Вам меньше 18 лет. Потребуется согласие родителя',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 240,
            height: 56,
            child: CustomButton(
              text: 'Продолжить',
              onPressed: _canContinue ? widget.onNext : null,
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
          widget.data['gender'] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
