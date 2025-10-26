import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'web_navbar.dart';
import 'web_footer.dart';

/// Обертка для всех страниц с navbar и footer
class PageWrapper extends StatelessWidget {
  final Widget child;
  final String? currentRoute;
  final bool showNavbar;
  final bool showFooter;
  final Color? backgroundColor;

  const PageWrapper({
    super.key,
    required this.child,
    this.currentRoute,
    this.showNavbar = true,
    this.showFooter = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundLight,
      body: Column(
        children: [
          if (showNavbar) WebNavbar(currentRoute: currentRoute),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [child, if (showFooter) const WebFooter()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
