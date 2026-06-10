import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Branded launch screen shown while the auth session resolves.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.onPrimary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'OnField',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your field, connected.',
              style: TextStyle(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
