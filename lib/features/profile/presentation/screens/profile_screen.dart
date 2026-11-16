import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/providers/auth_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: Column(
        children: [
          ProfileHeader(user: user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 8),
                const _SectionLabel('Account'),
                ProfileMenuTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () => context.push(RouteNames.editProfile),
                ),
                ProfileMenuTile(
                  icon: Icons.location_on_outlined,
                  title: 'My Addresses',
                  subtitle: 'Manage delivery addresses',
                  onTap: () => context.push(RouteNames.addresses),
                ),
                ProfileMenuTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order History',
                  subtitle: 'View your past orders',
                  onTap: () => context.push(RouteNames.orders),
                ),
                const SizedBox(height: 16),
                const _SectionLabel('Preferences'),
                ProfileMenuTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => context.push(RouteNames.settings),
                ),
                ProfileMenuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                ProfileMenuTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate the App',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                ProfileMenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  iconColor: AppColors.error,
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                  },
                  trailing: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label,
        style: AppTextStyles.labelMedium.copyWith(color: AppColors.textHint, letterSpacing: 1)),
  );
}