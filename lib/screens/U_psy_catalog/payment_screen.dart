import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';

/// Экран оплаты сеанса с психологом
class PaymentScreen extends StatefulWidget {
  final String psychologistName;
  final String psychologistImage;
  final String sessionDate;
  final String sessionTime;
  final int price;
  final String sessionFormat;

  const PaymentScreen({
    super.key,
    required this.psychologistName,
    required this.psychologistImage,
    required this.sessionDate,
    required this.sessionTime,
    required this.price,
    required this.sessionFormat,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'card'; // card, kaspi, halyk, paybox
  bool saveCard = false;
  bool agreedToTerms = false;

  // Контроллеры для полей карты
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Оплата сеанса',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о сеансе
                  _buildSessionInfo(),

                  const SizedBox(height: 24),

                  // Детали оплаты
                  _buildPriceBreakdown(),

                  const SizedBox(height: 24),

                  // Выбор способа оплаты
                  Text(
                    'Способ оплаты',
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  _buildPaymentMethods(),

                  const SizedBox(height: 24),

                  // Форма в зависимости от выбранного метода
                  if (selectedPaymentMethod == 'card') ...[
                    _buildCardForm(),
                  ] else ...[
                    _buildQuickPaymentInfo(),
                  ],

                  const SizedBox(height: 24),

                  // Чекбоксы
                  _buildCheckboxes(),
                ],
              ),
            ),
          ),

          // Кнопка оплаты
          _buildPaymentButton(),
        ],
      ),
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: NetworkImage(widget.psychologistImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.psychologistName,
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      widget.sessionFormat == 'video'
                          ? Icons.videocam_outlined
                          : Icons.chat_bubble_outline,
                      size: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.sessionFormat == 'video'
                          ? 'Видео-сессия'
                          : 'Чат-сессия',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.sessionDate}, ${widget.sessionTime}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final serviceFee = (widget.price * 0.05).round(); // 5% комиссия
    final total = widget.price + serviceFee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Стоимость сеанса', '${widget.price} ₸'),
          const SizedBox(height: 12),
          _buildPriceRow('Сервисный сбор', '$serviceFee ₸', isSecondary: true),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildPriceRow('Итого к оплате', '$total ₸', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount, {
    bool isSecondary = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.h3.copyWith(fontSize: 16)
              : AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  color: isSecondary
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? AppTextStyles.h2.copyWith(
                  fontSize: 24,
                  color: AppColors.primary,
                )
              : AppTextStyles.body1.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSecondary
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentMethodOption(
          'card',
          'Банковская карта',
          'Visa, MasterCard, МИР',
          Icons.credit_card,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'kaspi',
          'Kaspi.kz',
          'Оплата через Kaspi',
          Icons.account_balance_wallet,
          color: const Color(0xFFFF0000),
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          'halyk',
          'Halyk Bank',
          'Быстрая оплата',
          Icons.account_balance,
          color: const Color(0xFF00A651),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption(
    String value,
    String title,
    String subtitle,
    IconData icon, {
    Color? color,
  }) {
    final isSelected = selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (color ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.body3.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.inputBorder, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Данные карты', style: AppTextStyles.h3.copyWith(fontSize: 18)),
        const SizedBox(height: 16),

        // Номер карты
        _buildTextField(
          controller: cardNumberController,
          label: 'Номер карты',
          hint: '0000 0000 0000 0000',
          keyboardType: TextInputType.number,
          prefixIcon: Icons.credit_card,
          maxLength: 19,
        ),

        const SizedBox(height: 16),

        // Имя держателя
        _buildTextField(
          controller: cardHolderController,
          label: 'Имя на карте',
          hint: 'CARDHOLDER NAME',
          keyboardType: TextInputType.name,
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.characters,
        ),

        const SizedBox(height: 16),

        // Срок действия и CVV
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: expiryController,
                label: 'Срок действия',
                hint: 'MM/YY',
                keyboardType: TextInputType.number,
                maxLength: 5,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: cvvController,
                label: 'CVV',
                hint: '000',
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Сохранить карту
        Row(
          children: [
            Checkbox(
              value: saveCard,
              onChanged: (value) => setState(() => saveCard = value ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: Text(
                'Сохранить карту для будущих платежей',
                style: AppTextStyles.body2.copyWith(fontSize: 13),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Информация о безопасности
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.security, color: AppColors.success, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ваши данные защищены по стандарту PCI DSS',
                  style: AppTextStyles.body3.copyWith(
                    fontSize: 12,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    bool obscureText = false,
    int? maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body2.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            counterText: '',
            filled: true,
            fillColor: AppColors.cardBackground,
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
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPaymentInfo() {
    String paymentInfo = '';
    IconData icon = Icons.info_outline;
    Color color = AppColors.primary;

    switch (selectedPaymentMethod) {
      case 'kaspi':
        paymentInfo =
            'Вы будете перенаправлены в приложение Kaspi.kz для завершения оплаты';
        icon = Icons.phone_android;
        color = const Color(0xFFFF0000);
        break;
      case 'halyk':
        paymentInfo =
            'Вы будете перенаправлены в Halyk Bank для быстрой оплаты';
        icon = Icons.account_balance;
        color = const Color(0xFF00A651);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              paymentInfo,
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: agreedToTerms,
              onChanged: (value) =>
                  setState(() => agreedToTerms = value ?? false),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: GestureDetector(
                  onTap: () => setState(() => agreedToTerms = !agreedToTerms),
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      children: const [
                        TextSpan(text: 'Я согласен с '),
                        TextSpan(
                          text: 'условиями использования',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' и '),
                        TextSpan(
                          text: 'политикой конфиденциальности',
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    final serviceFee = (widget.price * 0.05).round();
    final total = widget.price + serviceFee;
    final canPay =
        agreedToTerms &&
        (selectedPaymentMethod != 'card' ||
            (cardNumberController.text.isNotEmpty &&
                cardHolderController.text.isNotEmpty &&
                expiryController.text.isNotEmpty &&
                cvvController.text.isNotEmpty));

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
      child: SafeArea(
        child: CustomButton(
          text: 'Оплатить $total ₸',
          onPressed: canPay ? _processPayment : null,
          isFullWidth: true,
        ),
      ),
    );
  }

  void _processPayment() {
    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Симуляция обработки платежа
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Закрыть индикатор

      // Показываем результат
      _showPaymentSuccess();
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Оплата успешна!',
              style: AppTextStyles.h2.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Ваш сеанс с ${widget.psychologistName} подтвержден',
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.sessionDate}, ${widget.sessionTime}',
              style: AppTextStyles.body1.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Отлично!',
              onPressed: () {
                Navigator.pop(context); // Закрыть диалог
                Navigator.pop(context); // Вернуться назад
                Navigator.pop(context); // Вернуться к каталогу
              },
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
