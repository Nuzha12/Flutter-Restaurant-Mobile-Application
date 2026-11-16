import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null
                    ? Text(user.name[0].toUpperCase(),
                    style: AppTextStyles.displayMedium.copyWith(color: AppColors.primary))
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(user.name, style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(user.email, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
          if (user.phone != null) ...[
            const SizedBox(height: 4),
            Text(user.phone!, style: AppTextStyles.bodySmall.copyWith(color: Colors.white60)),
          ],
        ],
      ),
    );
  }
}