import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.delivered:      return AppColors.success;
      case OrderStatus.cancelled:      return AppColors.error;
      case OrderStatus.outForDelivery: return AppColors.info;
      case OrderStatus.confirmed:      return AppColors.primary;
      case OrderStatus.preparing:      return AppColors.secondary;
      case OrderStatus.pending:        return AppColors.warning;
    }
  }

  IconData get _statusIcon {
    switch (order.status) {
      case OrderStatus.delivered:      return Icons.check_circle_rounded;
      case OrderStatus.cancelled:      return Icons.cancel_rounded;
      case OrderStatus.outForDelivery: return Icons.delivery_dining_rounded;
      case OrderStatus.confirmed:      return Icons.thumb_up_rounded;
      case OrderStatus.preparing:      return Icons.restaurant_rounded;
      case OrderStatus.pending:        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.orderDetail, extra: order),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin:  const EdgeInsets.only(bottom: 12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatters.orderNo(order.id),
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.dateTime(order.createdAt),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:        _statusColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _statusColor.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon,
                          color: _statusColor, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        order.statusLabel,
                        style: AppTextStyles.labelMedium
                            .copyWith(color: _statusColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Items summary
            Text(
              order.items
                  .map((i) => '${i.menuItem.name} ×${i.quantity}')
                  .join(' · '),
              style:    AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Footer row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      Formatters.itemCount(order.items.length),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                Text(
                  order.total.toCurrency,
                  style: AppTextStyles.priceSmall,
                ),
              ],
            ),

            // Track button for active orders
            if (order.isActive &&
                order.status == OrderStatus.outForDelivery) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.push(
                    RouteNames.orderTracking,
                    extra: order),
                child: Container(
                  width:   double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient:     AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Track Order',
                        style: AppTextStyles.labelMedium
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}