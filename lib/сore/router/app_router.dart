// lib/core/router/app_router.dart

import 'package:flutter/material.dart';
import '../../web_pages/auth/littleThings/forgot_password_page.dart';
import '../../web_pages/home/home_page.dart';
import '../../web_pages/auth/login_page.dart';
import '../../web_pages/auth/register/register_main.dart';
import '../../web_pages/about/about_page.dart';
import '../../web_pages/profile_patient/setting/change_password_page.dart';
import '../../web_pages/psychologists/psychologists_page.dart';
import '../../web_pages/psychologists/psychologist_detail.dart';
import '../../web_pages/profile_patient/blog_patient.dart';
import '../../web_pages/blog/article_detail.dart';
import '../../web_pages/services/services_page.dart';
import '../../web_pages/contacts/contacts_page.dart';
import '../../web_pages/profile_patient/home_patient.dart';
import '../../web_pages/profile_patient/profile_patient.dart';
import '../../web_pages/profile_patient/contacts_patient.dart';
import '../../web_pages/profile_patient/chat_patient.dart';
import '../../web_pages/profile_patient/edit_profile/edit_user.dart';
import '../../web_pages/profile_patient/setting/setting_page.dart';

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
  static const String articleReader = '/article-reader';
  static const String services = '/services';
  static const String contacts = '/contacts';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String contactsPatient = '/contacts-patient';
  static const String chatPatient = '/chat-patient';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String editProfile = '/edit-profile';
  static const String settingsRoute = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return NoAnimationMaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return NoAnimationMaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const RegisterMain(),
        );
      case about:
        return NoAnimationMaterialPageRoute(builder: (_) => const AboutPage());
      case psychologists:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const PsychologistsPage(),
        );
      case blog:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const BlogPatientPage(),
        );
      case services:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ServicesPage(),
        );
      case contacts:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ContactsPage(),
        );
      case dashboard:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const HomePatientPage(),
        );
      case profile:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ProfilePatientPage(),
        );
      case contactsPatient:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ContactsPatientPage(),
        );
      case chatPatient:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const ChatPatientPage(),
        );
      case articleReader:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const _ArticleReaderStub(),
        );
      case editProfile:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const EditProfilePage(),
        );

      case settingsRoute:
        return NoAnimationMaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());

      default:
        // Динамические маршруты
        if (settings.name?.startsWith('/psychologists/') == true) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(
            builder: (_) => PsychologistDetail(id: id),
          );
        }
        if (settings.name?.startsWith('/blog/') == true) {
          final id = settings.name!.split('/').last;
          return NoAnimationMaterialPageRoute(
            builder: (_) => ArticleDetail(id: id),
          );
        }
        return NoAnimationMaterialPageRoute(
          builder: (_) => const NotFoundPage(),
        );
    }
  }

  /// Получить имя маршрута для навигации
  static Map<String, String> get routes => {
    'Главная': home,
    'О нас': about,
    'Специалисты': psychologists,
    'Услуги': services,
    'Блог': blog,
    'Контакты': contacts,
    'Профиль': profile,
    'Дашборд': dashboard,
    'Сообщения': chatPatient,
  };
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({required super.builder, super.settings});

  @override
  Duration get transitionDuration => Duration.zero;
}

/// Временная заглушка для ArticleReader
class _ArticleReaderStub extends StatelessWidget {
  const _ArticleReaderStub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чтение статьи')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Чтение статьи',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Эта функция скоро будет доступна',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Страница 404
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Страница не найдена')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Страница не найдена', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text(
              'Запрошенная страница не существует',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (route) => false,
              ),
              child: const Text('На главную'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.maybePop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
