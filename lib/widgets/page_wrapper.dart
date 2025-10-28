// lib/widgets/page_wrapper.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home/header.dart';
import 'web_footer.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  final bool showHeader;
  final bool showFooter;
  final Color? backgroundColor;

  const PageWrapper({
    super.key,
    required this.child,
    required this.currentRoute,
    this.showHeader = true,
    this.showFooter = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundLight,
      body: Column(
        children: [
          if (showHeader) Header(currentRoute: currentRoute),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  child,
                  if (showFooter) const WebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}