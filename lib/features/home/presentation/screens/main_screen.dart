import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../notifications/providers/notification_provider.dart';
import '../screens/home_screen.dart';
import '../../../menu/presentation/screens/menu_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

final _navIndexProvider = StateProvider<int>((_) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const _screens = [HomeScreen(), MenuScreen(), OrdersScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx          = ref.watch(_navIndexProvider);
    final cartCount    = ref.watch(cartProvider).itemCount;
    final notifCount   = ref.watch(unreadCountProvider);

    return Scaffold(
      body: IndexedStack(index: idx, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
          border: const Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined,            activeIcon: Icons.home_rounded,              label: 'Home',   idx: 0, current: idx, onTap: () => ref.read(_navIndexProvider.notifier).state = 0),
                _NavItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu_rounded,   label: 'Menu',   idx: 1, current: idx, onTap: () => ref.read(_navIndexProvider.notifier).state = 1),
                _CartNavItem(count: cartCount, current: idx, onTap: () => context.push(RouteNames.cart)),
                _NavItem(icon: Icons.receipt_long_outlined,    activeIcon: Icons.receipt_long_rounded,      label: 'Orders', idx: 2, current: idx, onTap: () => ref.read(_navIndexProvider.notifier).state = 2),
                _NavItem(icon: Icons.person_outline_rounded,   activeIcon: Icons.person_rounded,            label: 'Profile', idx: 3, current: idx, onTap: () => ref.read(_navIndexProvider.notifier).state = 3, badge: notifCount),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String   label;
  final int      idx, current;
  final VoidCallback onTap;
  final int      badge;

  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.idx, required this.current, required this.onTap, this.badge = 0});

  bool get isActive => idx == current;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            badges.Badge(
              showBadge: badge > 0,
              badgeContent: Text('$badge', style: AppTextStyles.badge.copyWith(fontSize: 9)),
              badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.error, padding: EdgeInsets.all(4)),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(isActive ? activeIcon : icon,
                    key: ValueKey(isActive), size: 24,
                    color: isActive ? AppColors.primary : AppColors.textHint),
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.labelSmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.textHint, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _CartNavItem extends StatelessWidget {
  final int count, current;
  final VoidCallback onTap;
  const _CartNavItem({required this.count, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          badges.Badge(
            showBadge: count > 0,
            badgeContent: Text('$count', style: AppTextStyles.badge.copyWith(fontSize: 9)),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.primary, padding: EdgeInsets.all(4)),
            child: Container(
              width: 44, height: 44,
              decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}