import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
 import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../menu/providers/menu_provider.dart';
import '../../../notifications/providers/notification_provider.dart';
import '../../../menu/presentation/widgets/menu_item_card.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_chips.dart';
import '../widgets/featured_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user         = ref.watch(authProvider).user;
    final featuredAsync = ref.watch(featuredItemsProvider);
    final newAsync      = ref.watch(newItemsProvider);
    final menuAsync     = ref.watch(menuItemsProvider);
    final cartCount    = ref.watch(cartProvider).itemCount;
    final notifCount   = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            floating:        true,
            snap:            true,
            backgroundColor: AppColors.surface,
            elevation:       0,
            titleSpacing:    16,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        'New York, NY',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary, size: 14),
                    ],
                  ),
                ),
                Text(
                  'Hey ${user?.name.split(' ').first ?? 'there'} 👋',
                  style: AppTextStyles.headlineSmall,
                ),
              ],
            ),
            actions: [
              // Notification bell
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 26),
                    onPressed: () =>
                        context.push(RouteNames.notifications),
                  ),
                  if (notifCount > 0)
                    Positioned(
                      right: 8,
                      top:   8,
                      child: Container(
                        width:  16, height: 16,
                        decoration: const BoxDecoration(
                            color: AppColors.error, shape: BoxShape.circle),
                        child: Text(
                          '$notifCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // Cart button
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, size: 26),
                    onPressed: () => context.push(RouteNames.cart),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      right: 8,
                      top:   8,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Search bar + body ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  GestureDetector(
                    onTap: () => context.push(RouteNames.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color:        AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border:       Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: AppColors.textHint, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Search food, cuisines...',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textHint),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:        AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.tune_rounded,
                                color: AppColors.primary, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Banner
                  const BannerSlider(),
                  const SizedBox(height: 24),

                  // Categories
                  SectionHeader(
                    title: 'Categories',
                    actionLabel: 'See all',
                    onAction: () {
                      context.push(RouteNames.menu);
                    },
                  ),
                  const SizedBox(height: 12),
                  const CategoryChips(),
                  const SizedBox(height: 24),

                  // Featured
                  SectionHeader(
                    title: 'Bestsellers',
                    actionLabel: 'See all',
                    onAction: () {
                      GoRouter.of(context).push(RouteNames.menu);
                    },
                  ),
                  const SizedBox(height: 12),
                  featuredAsync.when(
                    loading: () => const ShimmerMenuGrid(),
                    error:   (_, __) => const SizedBox.shrink(),
                    data:    (items) => SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount:       items.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            FeaturedCard(item: items[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // New arrivals
                  SectionHeader(
                    title: 'New Arrivals ✨',
                    actionLabel: 'See all',
                    onAction: () {
                      GoRouter.of(context).push(RouteNames.menu);
                    },
                  ),
                  const SizedBox(height: 12),
                  newAsync.when(
                    loading: () => const ShimmerMenuGrid(),
                    error:   (_, __) => const SizedBox.shrink(),
                    data:    (items) => SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount:        items.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            FeaturedCard(item: items[i]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // All items header
                  SectionHeader(
                    title:       'All Items',
                    actionLabel: 'Sort & Filter',
                    onAction:    () {},
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── All items grid ───────────────────────────────────────────────
          menuAsync.when(
            loading: () =>
            const SliverToBoxAdapter(child: ShimmerMenuGrid()),
            error: (e, _) => SliverToBoxAdapter(
              child: EmptyStateWidget(
                icon:     Icons.error_outline_rounded,
                title:    'Something went wrong',
                subtitle: e.toString(),
              ),
            ),
            data: (items) => items.isEmpty
                ? const SliverToBoxAdapter(
              child: EmptyStateWidget(
                icon:     Icons.restaurant_menu_rounded,
                title:    'No items found',
                subtitle: 'Try a different category',
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => MenuItemCard(item: items[i]),
                  childCount: items.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:   2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing:  12,
                ),
              ),
            ),
          ),

          const SliverPadding(
              padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}