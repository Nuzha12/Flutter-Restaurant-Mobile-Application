import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/rating_widget.dart';
import '../../../../domain/models/menu_item_model.dart';
import '../../../cart/providers/cart_provider.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItemModel item;
  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.itemDetail, extra: item),
      child: Container(
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color:      AppColors.cardShadow,
              blurRadius: 10,
              offset:     Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image stack ──────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    height:   130,
                    width:    double.infinity,
                    fit:      BoxFit.cover,
                    placeholder: (_, __) => Container(
                        height: 130, color: AppColors.shimmerBase),
                    errorWidget: (_, __, ___) => Container(
                        height: 130, color: AppColors.surfaceVariant),
                  ),
                ),

                // Unavailable overlay
                if (!item.isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: Text('Unavailable',
                          style: AppTextStyles.labelLarge
                              .copyWith(color: Colors.white)),
                    ),
                  ),

                // Discount badge
                if (item.hasDiscount)
                  Positioned(
                    top:   8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color:        AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.discountPct.toInt()}% OFF',
                        style: AppTextStyles.badge,
                      ),
                    ),
                  ),

                // Tag badge
                if (item.tags.isNotEmpty)
                  Positioned(
                    top:  8,
                    left: 8,
                    child: _TagBadge(tag: item.tags.first),
                  ),
              ],
            ),

            // ── Info ─────────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  mainAxisAlignment:   MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style:    AppTextStyles.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            RatingWidget(
                                rating:    item.rating,
                                showCount: false,
                                size:      11),
                            const SizedBox(width: 4),
                            Text(
                              '• ${Formatters.minutesToReady(item.prepTimeMinutes)}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Price + add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.effectivePrice.toCurrency,
                                style: AppTextStyles.priceSmall),
                            if (item.hasDiscount)
                              Text(
                                item.price.toCurrency,
                                style: AppTextStyles.caption.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        if (item.isAvailable)
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .addItem(item);
                              context.showSnack(
                                'Added to cart',
                                icon: Icons.check_circle_outline,
                              );
                            },
                            child: Container(
                              width:  32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size:  18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tag badge ─────────────────────────────────────────────────────────────────

class _TagBadge extends StatelessWidget {
  final DietaryTag tag;
  const _TagBadge({required this.tag});

  @override
  Widget build(BuildContext context) {
    final (color, label) = _resolve(tag);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color:        color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(fontSize: 9),
      ),
    );
  }

  // Returns (color, label) — covers ALL enum cases including chefSpecial
  (Color, String) _resolve(DietaryTag tag) {
    switch (tag) {
      case DietaryTag.bestseller:  return (AppColors.warning,   '⭐ Best');
      case DietaryTag.new_:        return (AppColors.info,      '✨ New');
      case DietaryTag.spicy:       return (AppColors.error,     '🌶 Spicy');
      case DietaryTag.vegetarian:  return (AppColors.success,   '🌿 Veg');
      case DietaryTag.vegan:       return (AppColors.accent,    '🌱 Vegan');
      case DietaryTag.glutenFree:  return (AppColors.secondary, 'GF');
      case DietaryTag.chefSpecial: return (AppColors.gold,      '👨‍🍳 Chef');
    }
  }
}