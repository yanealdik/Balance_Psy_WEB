import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/custom_button.dart';

/// Экран редактирования профиля пользователя

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'АЛДИЯР БАЙДІЛДА');
  final _emailController = TextEditingController(text: 'user@example.com');
  final _phoneController = TextEditingController(text: '+7 (XXX) XXX-XX-XX');

  String _profileImageUrl = 'https://i.pravatar.cc/300?img=60';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save profile logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Профиль успешно обновлен',
            style: AppTextStyles.body1.copyWith(color: AppColors.textWhite),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _changePhoto() {
    // TODO: Implement image picker
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Изменить фото профиля', style: AppTextStyles.h3),
            const SizedBox(height: 20),
            _buildPhotoOption(
              icon: Icons.camera_alt,
              title: 'Сделать фото',
              onTap: () {
                Navigator.pop(context);
                // TODO: Open camera
              },
            ),
            const SizedBox(height: 12),
            _buildPhotoOption(
              icon: Icons.photo_library,
              title: 'Выбрать из галереи',
              onTap: () {
                Navigator.pop(context);
                // TODO: Open gallery
              },
            ),
            const SizedBox(height: 12),
            _buildPhotoOption(
              icon: Icons.delete_outline,
              title: 'Удалить фото',
              onTap: () {
                Navigator.pop(context);
                // TODO: Remove photo
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive
                ? AppColors.error.withOpacity(0.3)
                : AppColors.inputBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.body1,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.background,
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

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
        title: Text('Редактировать профиль', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Аватар с кнопкой редактирования
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(_profileImageUrl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changePhoto,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Поля ввода
                _buildInputField(
                  controller: _nameController,
                  label: 'Полное имя',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите ваше имя';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildInputField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                _buildInputField(
                  controller: _phoneController,
                  label: 'Телефон',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите номер телефона';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Информационная карточка
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ваши данные защищены и не будут переданы третьим лицам',
                          style: AppTextStyles.body2.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Кнопка сохранения
                CustomButton(
                  text: 'Сохранить изменения',
                  onPressed: _saveProfile,
                  isFullWidth: true,
                ),

                const SizedBox(height: 16),

                // Кнопка отмены
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'Отмена',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
