import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../providers/orders_provider.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => EmptyStateWidget(
          icon: Icons.error_outline, title: 'Error', subtitle: e.toString(),
        ),
        data: (orders) => orders.isEmpty
            ? const EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          subtitle: 'Your order history will appear here',
        )
            : RefreshIndicator(
          onRefresh: () => ref.read(ordersProvider.notifier).loadOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => OrderCard(order: orders[i]),
          ),
        ),
      ),
    );
  }
}