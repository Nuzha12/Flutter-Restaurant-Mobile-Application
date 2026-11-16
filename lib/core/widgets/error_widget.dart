import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08), shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            Text('Something went wrong', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(label: 'Try Again', onPressed: onRetry,
                  width: 160, size: AppButtonSize.medium, prefixIcon: Icons.refresh_rounded),
            ],
          ],
        ),
      ),
    );
  }
}