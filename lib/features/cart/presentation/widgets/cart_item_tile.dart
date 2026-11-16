import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../domain/models/cart_item_model.dart';
import '../../providers/cart_provider.dart';

class CartItemTile extends ConsumerWidget {
  final CartItemModel cartItem;

  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = cartItem.menuItem;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 80, height: 80, color: AppColors.shimmerBase),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTextStyles.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(item.price.toCurrency, style: AppTextStyles.priceSmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QBtn(
                      icon: Icons.remove,
                      onTap: () => ref.read(cartProvider.notifier)
                          .updateQuantity(item.id, cartItem.quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text('${cartItem.quantity}', style: AppTextStyles.headlineSmall),
                    ),
                    _QBtn(
                      icon: Icons.add,
                      onTap: () => ref.read(cartProvider.notifier)
                          .updateQuantity(item.id, cartItem.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => ref.read(cartProvider.notifier).removeItem(item.id),
              ),
              const SizedBox(height: 16),
              Text(cartItem.subtotal.toCurrency, style: AppTextStyles.priceSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primary, size: 16),
      ),
    );
  }
}