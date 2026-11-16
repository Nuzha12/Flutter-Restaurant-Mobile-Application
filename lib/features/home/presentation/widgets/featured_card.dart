import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/rating_widget.dart';
import '../../../../domain/models/menu_item_model.dart';
import '../../../cart/providers/cart_provider.dart';

class FeaturedCard extends ConsumerWidget {
  final MenuItemModel item;

  const FeaturedCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.itemDetail, extra: item),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 120, color: AppColors.shimmerBase),
                  ),
                ),
                if (item.tags.contains(DietaryTag.bestseller))
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.warning, borderRadius: BorderRadius.circular(6)),
                      child: Text('Bestseller',
                          style: AppTextStyles.labelMedium.copyWith(color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  RatingWidget(rating: item.rating, reviewCount: item.reviewCount, size: 11),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.price.toCurrency, style: AppTextStyles.priceSmall),
                      GestureDetector(
                        onTap: () {
                          ref.read(cartProvider.notifier).addItem(item);
                          context.showSnackBar('${item.name} added to cart');
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}