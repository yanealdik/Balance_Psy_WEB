import 'package:flutter/material.dart';
import '../../widgets/custom_navbar.dart';
import '../P_ReportsScreen/PsychologistReportsScreen.dart';
import '../P_ScheduleScreen/PsychologistScheduleScreen.dart';
import '../chats/U_chats/chats_screen.dart';
import '../home/P_home_screen/P_home_screen.dart';
import '../profile/U_profile/profile_screen.dart';

/// Главный контейнер приложения с нижней навигацией
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  // Список всех экранов
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const PsychologistHomeScreen(),
      const PsychologistScheduleScreen(),
      const PsychologistReportsScreen(),
      const ChatsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
