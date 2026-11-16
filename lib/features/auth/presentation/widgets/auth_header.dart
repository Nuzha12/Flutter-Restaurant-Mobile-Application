import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Text(AppConstants.appName,
                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 32),
        Text(title, style: AppTextStyles.displayMedium),
        const SizedBox(height: 6),
        Text(subtitle,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}