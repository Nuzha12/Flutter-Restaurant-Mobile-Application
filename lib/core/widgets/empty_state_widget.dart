import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData   icon;
  final String     title;
  final String     subtitle;
  final String?    actionLabel;
  final VoidCallback? onAction;
  final double     iconSize;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: AppColors.primary.withOpacity(0.7)),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(title, style: AppTextStyles.headlineMedium, textAlign: TextAlign.center)
                .animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
            const SizedBox(height: 8),
            Text(subtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center)
                .animate().fadeIn(delay: 150.ms),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              AppButton(label: actionLabel!, onPressed: onAction, width: 180, size: AppButtonSize.medium),
            ],
          ],
        ),
      ),
    );
  }
}