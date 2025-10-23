import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final DateTime? initialDate;
  final Function(Map<String, dynamic>)? onAppointmentCreated;

  const CreateAppointmentScreen({
    super.key,
    this.initialDate,
    this.onAppointmentCreated,
  });

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Данные формы
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedFormat = 'video';
  String _selectedIssue = '';

  bool _isUserFound = false;
  bool _isSearching = false;
  Map<String, dynamic>? _foundUser;

  final List<Map<String, dynamic>> _issues = [
    {
      'title': 'Тревожность',
      'icon': Icons.psychology,
      'color': Color(0xFFFF6B6B),
    },
    {'title': 'Депрессия', 'icon': Icons.cloud, 'color': Color(0xFF4ECDC4)},
    {'title': 'Отношения', 'icon': Icons.favorite, 'color': Color(0xFFFF8ED4)},
    {'title': 'Самооценка', 'icon': Icons.star, 'color': Color(0xFFFFA94D)},
    {'title': 'Стресс', 'icon': Icons.flash_on, 'color': Color(0xFFFFD93D)},
    {'title': 'Другое', 'icon': Icons.more_horiz, 'color': Color(0xFF95E1D3)},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Имитация поиска пользователя по номеру
  Future<void> _searchUserByPhone(String phone) async {
    if (phone.length < 10) return;

    setState(() => _isSearching = true);

    // Имитация API запроса
    await Future.delayed(const Duration(seconds: 1));

    // Симуляция: если номер заканчивается на четное число - пользователь найден
    final lastDigit = int.tryParse(phone[phone.length - 1]) ?? 0;
    final userExists = lastDigit % 2 == 0;

    setState(() {
      _isSearching = false;
      _isUserFound = userExists;

      if (userExists) {
        _foundUser = {
          'name': 'Анна Ким',
          'phone': phone,
          'image': 'https://i.pravatar.cc/150?img=25',
          'isRegistered': true,
        };
        _nameController.text = _foundUser!['name'];
      } else {
        _foundUser = null;
        _nameController.clear();
      }
    });
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveAppointment();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveAppointment() {
    final appointment = {
      'name': _nameController.text.isEmpty ? 'Гость' : _nameController.text,
      'phone': _phoneController.text,
      'image':
          _foundUser?['image'] ??
          'https://i.pravatar.cc/150?img=${DateTime.now().millisecond}',
      'date': _selectedDate,
      'time':
          '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'format': _selectedFormat,
      'issue': _selectedIssue,
      'notes': _notesController.text,
      'status': _isUserFound ? 'Приглашение отправлено' : 'Гостевая запись',
      'statusColor': _isUserFound
          ? const Color(0xFFE3F2FD)
          : const Color(0xFFFFF4E0),
      'statusTextColor': _isUserFound
          ? const Color(0xFF1976D2)
          : const Color(0xFFD4A747),
      'isGuest': !_isUserFound,
    };

    widget.onAppointmentCreated?.call(appointment);
    Navigator.pop(context, appointment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            const SizedBox(height: 24),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  _buildStep1(), // Поиск пользователя
                  _buildStep2(), // Дата и время
                  _buildStep3(), // Формат и проблема
                  _buildStep4(), // Подтверждение
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.cardBackground,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Новая запись',
                  style: AppTextStyles.h2.copyWith(fontSize: 24),
                ),
                Text(
                  'Шаг ${_currentStep + 1} из 4',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(4, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              height: 6,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppColors.primary
                    : AppColors.inputBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Шаг 1: Поиск пользователя
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text('Поиск клиента', style: AppTextStyles.h2.copyWith(fontSize: 26)),
          const SizedBox(height: 8),
          Text(
            'Введите номер телефона для поиска или создайте гостевую запись',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),

          // Поле поиска
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              if (value.length >= 10) {
                _searchUserByPhone(value);
              } else {
                setState(() {
                  _isUserFound = false;
                  _foundUser = null;
                });
              }
            },
            style: AppTextStyles.body1.copyWith(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Номер телефона',
              hintText: '+7 (___) ___-__-__',
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
              suffixIcon: _isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _isUserFound
                  ? Icon(Icons.check_circle, color: AppColors.success)
                  : _phoneController.text.length >= 10
                  ? Icon(Icons.person_add, color: AppColors.warning)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: AppColors.cardBackground,
            ),
          ),

          const SizedBox(height: 20),

          // Результат поиска
          if (_isUserFound && _foundUser != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(_foundUser!['image']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Пользователь найден',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _foundUser!['name'],
                          style: AppTextStyles.h3.copyWith(fontSize: 17),
                        ),
                        Text(
                          'Приглашение будет отправлено',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_phoneController.text.length >= 10 && !_isSearching) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    color: AppColors.warning,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Пользователь не найден',
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 16,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Будет создана гостевая запись. Вы можете указать имя клиента ниже',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: AppTextStyles.body1.copyWith(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Имя клиента (необязательно)',
                hintText: 'Например: Анна Ким',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Шаг 2: Дата и время
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_month,
              size: 48,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Когда назначить приём?',
            style: AppTextStyles.h2.copyWith(fontSize: 26),
          ),

          const SizedBox(height: 8),

          Text(
            'Выберите удобные дату и время',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 32),

          // Дата
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today,
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
                          'Дата приёма',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(_selectedDate),
                          style: AppTextStyles.h3.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Время
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedTime = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time,
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
                          'Время приёма',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                          style: AppTextStyles.h3.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Шаг 3: Формат и проблема
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, size: 48, color: AppColors.primary),
            ),

            const SizedBox(height: 24),

            Text(
              'Детали консультации',
              style: AppTextStyles.h2.copyWith(fontSize: 26),
            ),

            const SizedBox(height: 8),

            Text(
              'Выберите формат и тему обращения',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 32),

            // Формат
            Text(
              'Формат консультации',
              style: AppTextStyles.h3.copyWith(fontSize: 16),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFormatOption('video', 'Видео', Icons.videocam),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFormatOption('audio', 'Аудио', Icons.phone),
                ),
                const SizedBox(width: 12),
                Expanded(child: _buildFormatOption('chat', 'Чат', Icons.chat)),
              ],
            ),

            const SizedBox(height: 32),

            // Проблема
            Text(
              'Тема обращения',
              style: AppTextStyles.h3.copyWith(fontSize: 16),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _issues.map((issue) {
                final isSelected = _selectedIssue == issue['title'];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIssue = issue['title']);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? issue['color'].withOpacity(0.15)
                          : AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? issue['color']
                            : AppColors.inputBorder,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          issue['icon'],
                          color: isSelected
                              ? issue['color']
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          issue['title'],
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 14,
                            color: isSelected
                                ? issue['color']
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

            const SizedBox(height: 24),

            // Заметки
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Дополнительные заметки (необязательно)',
                hintText: 'Укажите важные детали...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Шаг 4: Подтверждение
  Widget _buildStep4() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 48,
                color: AppColors.success,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Проверьте данные',
              style: AppTextStyles.h2.copyWith(fontSize: 26),
            ),

            const SizedBox(height: 8),

            Text(
              'Убедитесь, что всё заполнено корректно',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 32),

            // Сводка
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  _buildSummaryItem(
                    Icons.person,
                    'Клиент',
                    _nameController.text.isEmpty
                        ? 'Не указано'
                        : _nameController.text,
                  ),
                  const Divider(height: 24),
                  _buildSummaryItem(
                    Icons.phone,
                    'Телефон',
                    _phoneController.text.isEmpty
                        ? 'Не указан'
                        : _phoneController.text,
                  ),
                  const Divider(height: 24),
                  _buildSummaryItem(
                    Icons.calendar_today,
                    'Дата',
                    _formatDate(_selectedDate),
                  ),
                  const Divider(height: 24),
                  _buildSummaryItem(
                    Icons.access_time,
                    'Время',
                    '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryItem(
                    _getFormatIcon(_selectedFormat),
                    'Формат',
                    _getFormatName(_selectedFormat),
                  ),
                  if (_selectedIssue.isNotEmpty) ...[
                    const Divider(height: 24),
                    _buildSummaryItem(Icons.psychology, 'Тема', _selectedIssue),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (value) => setState(() {}),
      style: AppTextStyles.body1.copyWith(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.cardBackground,
      ),
    );
  }

  Widget _buildFormatOption(String value, String label, IconData icon) {
    final isSelected = _selectedFormat == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedFormat = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                fontSize: 13,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.inputBorder, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Назад',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: CustomButton(
              text: _currentStep == 3 ? 'Создать запись' : 'Далее',
              onPressed: _canProceed() ? _nextStep : null,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty;
      case 1:
        return true;
      case 2:
        return _selectedIssue.isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
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

  IconData _getFormatIcon(String format) {
    switch (format) {
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.phone;
      case 'chat':
        return Icons.chat;
      default:
        return Icons.videocam;
    }
  }

  String _getFormatName(String format) {
    switch (format) {
      case 'video':
        return 'Видеоконсультация';
      case 'audio':
        return 'Аудиоконсультация';
      case 'chat':
        return 'Чат';
      default:
        return 'Видеоконсультация';
    }
  }
}
