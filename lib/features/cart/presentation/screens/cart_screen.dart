import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/order_summary_card.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: const Text('Clear', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? EmptyStateWidget(
        icon: Icons.shopping_bag_outlined,
        title: 'Your cart is empty',
        subtitle: 'Browse our menu and add delicious items',
        actionLabel: 'Browse Menu',
        onAction: () => context.go(RouteNames.main),
      )
          : Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...cart.items.map((ci) => CartItemTile(cartItem: ci)),
                const SizedBox(height: 16),
                OrderSummaryCard(
                  subtotal: cart.subtotal,
                  deliveryFee: cart.deliveryFee,
                  tax: cart.tax,
                  total: cart.total,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: AppButton(
            label: 'Proceed to Checkout',
            onPressed: () => context.push(RouteNames.checkout),
          ),
        ),
      ),
    );
  }
}