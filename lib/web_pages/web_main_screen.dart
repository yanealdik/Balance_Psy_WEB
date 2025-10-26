import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_button.dart';

/// Entry point для веб-версии Balance Psy
/// Запуск: flutter run -d chrome -t lib/web_main.dart
void main() {
  runApp(const BalancePsyWeb());
}

class BalancePsyWeb extends StatelessWidget {
  const BalancePsyWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BalancePsy - Онлайн психотерапия',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.cardBackground,
          error: AppColors.error,
        ),
      ),
      home: const WebMainScreen(),
    );
  }
}

class WebMainScreen extends StatefulWidget {
  const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  int _selectedNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final _navItems = [
    'Главная',
    'О нас',
    'Специалисты',
    'Услуги',
    'Отзывы',
    'Контакты',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeader(context),
            _buildHeroSection(context),
            _buildMissionSection(context),
            _buildHowItWorksSection(context),
            _buildPsychologistsSection(context),
            _buildStepsSection(context),
            _buildArticlesSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Хедер с навигацией
  Widget _buildHeader(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Логотип
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Balance',
                style: AppTextStyles.logo.copyWith(
                  fontSize: isMobile ? 20 : 24,
                ),
              ),
              Text(
                'Psy',
                style: AppTextStyles.logo.copyWith(
                  fontSize: isMobile ? 20 : 24,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Навигация для десктопа
          if (!isMobile && !isTablet)
            Row(
              children: _navItems.asMap().entries.map((entry) {
                final isSelected = entry.key == _selectedNavIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _selectedNavIndex = entry.key),
                    child: Text(
                      entry.value,
                      style: AppTextStyles.body1.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          // Кнопка "Войти"
          if (!isMobile)
            SizedBox(
              width: 140,
              height: 48,
              child: CustomButton(
                text: 'Войти',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                isPrimary: true,
                isFullWidth: true,
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => _showMobileMenu(context),
            ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ..._navItems.asMap().entries.map((entry) {
              return ListTile(
                title: Text(
                  entry.value,
                  style: AppTextStyles.body1.copyWith(
                    color: entry.key == _selectedNavIndex
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedNavIndex = entry.key);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: CustomButton(
                  text: 'Войти',
                  onPressed: () {},
                  isPrimary: true,
                  isFullWidth: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Hero-секция
  Widget _buildHeroSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      child: isMobile
          ? Column(
              children: [
                _buildHeroContent(isMobile, isTablet),
                const SizedBox(height: 40),
                _buildHeroImage(isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildHeroContent(isMobile, isTablet)),
                const SizedBox(width: 60),
                Expanded(child: _buildHeroImage(isMobile)),
              ],
            ),
    );
  }

  Widget _buildHeroContent(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Сервис онлайн-психотерапии',
          style: AppTextStyles.body2.copyWith(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Твоя ',
                style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 32 : 48),
              ),
              TextSpan(
                text: 'поддержка\n',
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 32 : 48,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: 'Твой ',
                style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 32 : 48),
              ),
              TextSpan(
                text: 'баланс',
                style: AppTextStyles.h1.copyWith(
                  fontSize: isMobile ? 32 : 48,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        Text(
          'Получите профессиональную психологическую помощь онлайн в удобное для вас время',
          style: AppTextStyles.body1.copyWith(
            fontSize: isMobile ? 16 : 18,
            color: AppColors.textSecondary,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: isMobile ? double.infinity : 240,
          height: 56,
          child: CustomButton(
            text: 'Выбрать психолога',
            onPressed: () {},
            isPrimary: true,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage(bool isMobile) {
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.15),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.phone_iphone_rounded,
          size: isMobile ? 120 : 180,
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Секция "С чем помогут психологи"
  Widget _buildMissionSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    final items = [
      {'title': 'Справиться с тревогой и стрессом', 'emoji': '😰'},
      {'title': 'Понять, почему трудно научиться доверять', 'emoji': '🤔'},
      {
        'title': 'Получить самообладание – получить свободу действий',
        'emoji': '😌',
      },
      {
        'title': 'Найти смысл – почувствовать что хочется предпринимать',
        'emoji': '💪',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'С чем помогут психологи',
            style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 28 : 40),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: items
                .map((item) => _buildMissionCard(item, isMobile, isTablet))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(
    Map<String, String> item,
    bool isMobile,
    bool isTablet,
  ) {
    final cardWidth = isMobile ? double.infinity : (isTablet ? 300.0 : 260.0);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(item['emoji']!, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item['title']!,
            style: AppTextStyles.body1.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Секция "Как это работает"
  Widget _buildHowItWorksSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        children: [
          Text(
            'Как это работает',
            style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 28 : 40),
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: [
                    _buildHowItWorksStep(
                      '1',
                      'Регистрация',
                      'Создайте аккаунт за 2 минуты',
                    ),
                    const SizedBox(height: 24),
                    _buildHowItWorksStep(
                      '2',
                      'Выбор психолога',
                      'Подберите специалиста под ваш запрос',
                    ),
                    const SizedBox(height: 24),
                    _buildHowItWorksStep(
                      '3',
                      'Консультация',
                      'Проведите сеанс онлайн в удобное время',
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildHowItWorksStep(
                        '1',
                        'Регистрация',
                        'Создайте аккаунт за 2 минуты',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildHowItWorksStep(
                        '2',
                        'Выбор психолога',
                        'Подберите специалиста под ваш запрос',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildHowItWorksStep(
                        '3',
                        'Консультация',
                        'Проведите сеанс онлайн в удобное время',
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksStep(String number, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Секция с психологами
  Widget _buildPsychologistsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    final psychologists = [
      {'name': 'Галия Аубакирова', 'spec': '8 лет опыта', 'rating': '4.9'},
      {'name': 'Яна Прозорова', 'spec': '10 лет опыта', 'rating': '5.0'},
      {'name': 'Лаура Болдина', 'spec': '7 лет опыта', 'rating': '4.8'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Команда психологов',
            style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 28 : 40),
          ),
          const SizedBox(height: 16),
          Text(
            'Специализированные психологи со стажем работы',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: psychologists
                .map((psy) => _buildPsychologistCard(psy, isMobile, isTablet))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologistCard(
    Map<String, String> psy,
    bool isMobile,
    bool isTablet,
  ) {
    final cardWidth = isMobile ? double.infinity : (isTablet ? 280.0 : 300.0);

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 60, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(psy['name']!, style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Text(psy['spec']!, style: AppTextStyles.body2),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: AppColors.warning, size: 20),
              const SizedBox(width: 4),
              Text(psy['rating']!, style: AppTextStyles.body1),
            ],
          ),
        ],
      ),
    );
  }

  /// Секция "Сделай шаг к заботе о себе"
  Widget _buildStepsSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      child: Column(
        children: [
          Text(
            'Сделай шаг к заботе о себе',
            style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 28 : 40),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          isMobile
              ? Column(
                  children: [
                    _buildStepCard(
                      '1',
                      'Укажите темы, с которыми хотите поработать',
                    ),
                    const SizedBox(height: 24),
                    _buildStepCard(
                      '2',
                      'Выберите комфортную для себя стоимость сессии',
                    ),
                    const SizedBox(height: 24),
                    _buildStepCard(
                      '3',
                      'Получите подборку опытных специалистов под ваш запрос',
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildStepCard(
                        '1',
                        'Укажите темы, с которыми хотите поработать',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildStepCard(
                        '2',
                        'Выберите комфортную для себя стоимость сессии',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildStepCard(
                        '3',
                        'Получите подборку опытных специалистов под ваш запрос',
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 48),
          SizedBox(
            width: isMobile ? double.infinity : 280,
            height: 56,
            child: CustomButton(
              text: 'Начать прямо сейчас',
              onPressed: () {},
              isPrimary: true,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String number, String text) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: AppTextStyles.h1.copyWith(
              fontSize: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(text, style: AppTextStyles.body1, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  /// Секция со статьями
  Widget _buildArticlesSection(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: isMobile ? 40 : 80,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Читайте актуальные статьи от наших психологов',
            style: AppTextStyles.h1.copyWith(fontSize: isMobile ? 24 : 36),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  AppColors.backgroundLight,
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 100,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Скоро здесь появятся полезные статьи',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Футер
  Widget _buildFooter(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
        vertical: 40,
      ),
      color: AppColors.textPrimary,
      child: Column(
        children: [
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Balance',
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Psy',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Онлайн-платформа для психологической поддержки',
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _buildFooterLinks('Навигация', [
                    'О нас',
                    'Психологи',
                    'Статьи',
                    'Контакты',
                  ]),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _buildFooterLinks('Поддержка', [
                    'FAQ',
                    'Политика конфиденциальности',
                    'Условия использования',
                  ]),
                ),
              ],
            )
          else
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Balance',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Psy',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Онлайн-платформа для психологической поддержки',
                  style: AppTextStyles.body2.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            '© 2025 BalancePsy. Все права защищены',
            style: AppTextStyles.body3.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {},
              child: Text(
                link,
                style: AppTextStyles.body2.copyWith(color: Colors.white70),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
