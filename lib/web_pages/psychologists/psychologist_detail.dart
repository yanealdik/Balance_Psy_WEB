import 'package:flutter/material.dart';
import '../../widgets/page_wrapper.dart';
import '../../theme/app_text_styles.dart';
import '../../сore/router/app_router.dart';

class PsychologistDetail extends StatelessWidget {
  final String id;
  const PsychologistDetail({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 100, color: Color(0xFF57A2EB)),
              const SizedBox(height: 24),
              Text('Психолог #$id', style: AppTextStyles.h1),
              const SizedBox(height: 16),
              Text(
                'Раздел в разработке',
                style: AppTextStyles.body1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
