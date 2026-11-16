import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/rating_widget.dart';
import '../../../../domain/models/menu_item_model.dart';
import '../../../../domain/models/review_model.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../widgets/quantity_selector.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final MenuItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(itemReviewsProvider(widget.item.id));
    final item         = widget.item;
    final total        = item.effectivePrice * _quantity;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned:          true,
            backgroundColor: AppColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.textPrimary, size: 20),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Consumer(builder: (_, ref, __) {
                    final isFav = ref.watch(favoritesProvider).contains(item.id);
                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.error : AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () =>
                          ref.read(favoritesProvider.notifier).toggle(item.id),
                    );
                  }),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl:    item.imageUrl,
                    fit:         BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.shimmerBase),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.surfaceVariant),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black45],
                        begin:  Alignment.topCenter,
                        end:    Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.name,
                            style: AppTextStyles.headlineLarge),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.effectivePrice.toCurrency,
                              style: AppTextStyles.price),
                          if (item.hasDiscount)
                            Text(
                              item.price.toCurrency,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Meta row
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      RatingWidget(
                          rating: item.rating,
                          reviewCount: item.reviewCount),
                      _MetaChip(
                        icon: Icons.access_time_rounded,
                        label: Formatters.minutesToReady(item.prepTimeMinutes),
                      ),
                      _MetaChip(
                        icon: Icons.local_fire_department_rounded,
                        label: '${item.calories} cal',
                        iconColor: AppColors.secondary,
                      ),
                      _MetaChip(
                        icon: Icons.star_outline_rounded,
                        label: '+${item.loyaltyPoints} pts',
                        iconColor: AppColors.gold,
                      ),
                    ],
                  ),

                  // Discount badge
                  if (item.hasDiscount) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${item.discountPct.toInt()}% OFF',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: AppColors.success),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const _Divider(label: 'Description'),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary, height: 1.7),
                  ),

                  if (item.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _Divider(label: 'Ingredients'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.ingredients
                          .map((ing) => _IngredientChip(label: ing))
                          .toList(),
                    ),
                  ],

                  if (item.allergens.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _Divider(label: 'Allergens'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.allergens
                          .map((a) => _AllergenChip(label: a))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity', style: AppTextStyles.headlineSmall),
                      QuantitySelector(
                        quantity:    _quantity,
                        onIncrement: () =>
                            setState(() => _quantity++),
                        onDecrement: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const _Divider(label: 'Reviews'),
                  const SizedBox(height: 12),
                  reviewsAsync.when(
                    loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )),
                    error:   (_, __) => const SizedBox.shrink(),
                    data:    (reviews) => Column(
                      children: reviews
                          .map((r) => _ReviewTile(review: r))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: AppButton(
            label:     'Add to Cart • ${total.toCurrency}',
            gradient:  AppColors.primaryGradient,
            onPressed: () {
              ref
                  .read(cartProvider.notifier)
                  .addItem(item, quantity: _quantity);
              context.showSnack(
                '${item.name} added to cart',
                icon: Icons.shopping_bag_outlined,
              );
              context.pop();
            },
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String   label;
  final Color    iconColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.headlineSmall),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String label;
  const _IngredientChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:        AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: AppColors.divider),
      ),
      child: Text(label, style: AppTextStyles.bodySmall),
    );
  }
}

class _AllergenChip extends StatelessWidget {
  final String label;
  const _AllergenChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:        AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 13, color: AppColors.warning),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.warning)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius:          22,
            backgroundColor: AppColors.surfaceVariant,
            backgroundImage: review.userAvatar != null
                ? NetworkImage(review.userAvatar!)
                : null,
            child: review.userAvatar == null
                ? Text(
              review.userName.isNotEmpty
                  ? review.userName[0].toUpperCase()
                  : '?',
              style: AppTextStyles.titleMedium
                  .copyWith(color: AppColors.primary),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:        AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(review.userName,
                          style: AppTextStyles.titleMedium),
                      RatingWidget(
                          rating:    review.rating,
                          showCount: false,
                          size:      11),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.comment,
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.relativeTime(review.createdAt),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}