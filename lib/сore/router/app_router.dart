import 'package:flutter/material.dart';
import '../../web_pages/home/home_page.dart';
import '../../web_pages/auth/login_page.dart';
import '../../web_pages/auth/register/register_main.dart';
import '../../web_pages/about/about_page.dart';
import '../../web_pages/psychologists/psychologists_page.dart';
import '../../web_pages/psychologists/psychologist_detail.dart';
import '../../web_pages/blog/blog_page.dart';
import '../../web_pages/blog/article_detail.dart';
import '../../web_pages/services/services_page.dart';
import '../../web_pages/contacts/contacts_page.dart';
import '../../web_pages/dashboard/dashboard_page.dart';

/// Централизованный роутинг для веб-версии BalancePsy
class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String about = '/about';
  static const String psychologists = '/psychologists';
  static const String psychologistDetail = '/psychologists/:id';
  static const String blog = '/blog';
  static const String articleDetail = '/blog/:id';
  static const String services = '/services';
  static const String contacts = '/contacts';
  static const String dashboard = '/dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomePage());
      case login:
        return _buildRoute(const LoginPage());
      case register:
        return _buildRoute(const RegisterMain());
      case about:
        return _buildRoute(const AboutPage());
      case psychologists:
        return _buildRoute(const PsychologistsPage());
      case blog:
        return _buildRoute(const BlogPage());
      case services:
        return _buildRoute(const ServicesPage());
      case contacts:
        return _buildRoute(const ContactsPage());
      case dashboard:
        return _buildRoute(const DashboardPage());
      default:
        // Обработка динамических маршрутов
        if (settings.name?.startsWith('/psychologists/') == true) {
          final id = settings.name!.split('/').last;
          return _buildRoute(PsychologistDetail(id: id));
        }
        if (settings.name?.startsWith('/blog/') == true) {
          final id = settings.name!.split('/').last;
          return _buildRoute(ArticleDetail(id: id));
        }
        return _buildRoute(const NotFoundPage());
    }
  }

  static PageRoute _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.05);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: curve));
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Получить имя маршрута для навигации
  static Map<String, String> get routes => {
    'Главная': home,
    'О нас': about,
    'Специалисты': psychologists,
    'Услуги': services,
    'Блог': blog,
    'Контакты': contacts,
  };
}

/// Страница 404
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '404',
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Страница не найдена', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRouter.home),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  }
}
