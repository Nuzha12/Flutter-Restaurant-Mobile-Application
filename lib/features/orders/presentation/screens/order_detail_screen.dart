import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/models/order_model.dart';
import '../widgets/order_status_stepper.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Formatters.orderNo(order.id)),
        actions: [
          if (order.isActive)
            TextButton.icon(
              onPressed: () =>
                  context.push(RouteNames.orderTracking, extra: order),
              icon: const Icon(Icons.location_on_outlined, size: 16),
              label: const Text('Track'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Status',
                        style: AppTextStyles.headlineSmall),
                    _StatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 20),
                if (order.status != OrderStatus.cancelled)
                  OrderStatusStepper(status: order.status)
                else
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:        AppColors.error.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.error.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel_outlined,
                            color: AppColors.error, size: 18),
                        const SizedBox(width: 10),
                        Text('This order was cancelled.',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.error)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Items card
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items Ordered',
                    style: AppTextStyles.headlineSmall),
                const SizedBox(height: 14),
                ...order.items.map(
                      (ci) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${ci.menuItem.name} × ${ci.quantity}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        Text(ci.subtotal.toCurrency,
                            style: AppTextStyles.priceSmall),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                _SummaryRow('Subtotal', order.subtotal.toCurrency),
                const SizedBox(height: 6),
                _SummaryRow(
                  'Delivery',
                  order.deliveryFee == 0
                      ? 'Free 🎉'
                      : order.deliveryFee.toCurrency,
                  valueColor: order.deliveryFee == 0
                      ? AppColors.success
                      : null,
                ),
                const SizedBox(height: 6),
                _SummaryRow('Tax', order.tax.toCurrency),
                if (order.discount > 0) ...[
                  const SizedBox(height: 6),
                  _SummaryRow(
                    'Discount',
                    '- ${order.discount.toCurrency}',
                    valueColor: AppColors.success,
                  ),
                ],
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.headlineSmall),
                    Text(order.total.toCurrency,
                        style: AppTextStyles.price),
                  ],
                ),
                if (order.loyaltyEarned > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient:     AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⭐',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          '+${order.loyaltyEarned} points earned',
                          style: AppTextStyles.labelMedium
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Address card
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Address',
                    style: AppTextStyles.headlineSmall),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:        AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.deliveryAddress.label,
                              style: AppTextStyles.titleMedium),
                          const SizedBox(height: 2),
                          Text(
                            order.deliveryAddress.fullAddress,
                            style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Payment card
          _Card(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:        AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.credit_card_rounded,
                      color: AppColors.info, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                      Text(
                        order.paymentMethod.name.toUpperCase(),
                        style: AppTextStyles.titleMedium,
                      ),
                    ],
                  ),
                ),
                if (order.promoCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:        AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.promoCode!,
                      style: AppTextStyles.labelMedium
                          .copyWith(color: AppColors.success),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (order.status == OrderStatus.outForDelivery ||
              order.status == OrderStatus.preparing)
            AppButton(
              label:      'Track Live Order',
              prefixIcon: Icons.location_on_rounded,
              onPressed:  () => context.push(
                  RouteNames.orderTracking,
                  extra: order),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color:      AppColors.cardShadow,
            blurRadius: 10,
            offset:     Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary)),
        Text(value,
            style: AppTextStyles.bodyMedium
                .copyWith(color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case OrderStatus.delivered:      return AppColors.success;
      case OrderStatus.cancelled:      return AppColors.error;
      case OrderStatus.outForDelivery: return AppColors.info;
      case OrderStatus.confirmed:      return AppColors.primary;
      case OrderStatus.preparing:      return AppColors.secondary;
      case OrderStatus.pending:        return AppColors.warning;
    }
  }

  String get _label {
    switch (status) {
      case OrderStatus.delivered:      return 'Delivered';
      case OrderStatus.cancelled:      return 'Cancelled';
      case OrderStatus.outForDelivery: return 'On the way';
      case OrderStatus.confirmed:      return 'Confirmed';
      case OrderStatus.preparing:      return 'Preparing';
      case OrderStatus.pending:        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(_label,
          style: AppTextStyles.labelMedium
              .copyWith(color: _color, fontSize: 11)),
    );
  }
}