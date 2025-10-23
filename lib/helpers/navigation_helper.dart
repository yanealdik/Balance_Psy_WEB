import 'package:flutter/material.dart';

class NavigationHelper {
  // Универсальный метод навигации
  static void navigateTo(BuildContext context, int index, {String? stateType}) {
    if (stateType == 'user' || stateType == null) {
      try {
        final userState = context.findAncestorStateOfType<State>();
        if (userState != null &&
            userState.widget.runtimeType.toString().contains('HomeScreen')) {
          (userState as dynamic).navigateToTab(index);
          return;
        }
      } catch (e) {
        // Продолжаем поиск
      }
    }

    if (stateType == 'psychologist' || stateType == null) {
      try {
        final psychState = context.findAncestorStateOfType<State>();
        if (psychState != null &&
            psychState.widget.runtimeType.toString().contains(
              'MainContainer',
            )) {
          (psychState as dynamic).navigateToTab(index);
          return;
        }
      } catch (e) {
        // Ничего не делаем
      }
    }
  }

  // Именованные методы
  static void goToHome(BuildContext context) => navigateTo(context, 0);
  static void goToSecond(BuildContext context) => navigateTo(context, 1);
  static void goToThird(BuildContext context) => navigateTo(context, 2);
  static void goToChats(BuildContext context) => navigateTo(context, 3);
  static void goToProfile(BuildContext context) => navigateTo(context, 4);
}
