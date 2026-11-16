import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/models/order_model.dart';
import '../widgets/order_status_stepper.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 56),
                  const SizedBox(height: 12),
                  Text('Your order is on its way!',
                      style: AppTextStyles.headlineMedium.copyWith(color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Estimated delivery: ${Formatters.minutesToReady(order.estimatedMinutes)}',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Order Progress', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 20),
            OrderStatusStepper(status: order.status),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=33'),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Marcus Rivera', style: AppTextStyles.titleMedium),
                        Text('Your delivery partner',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.phone_rounded, color: AppColors.primary, size: 20),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'View Order Details',
              variant: AppButtonVariant.outline,
              onPressed: () => context.push(RouteNames.orderDetail, extra: order),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Back to Home',
              onPressed: () => context.go(RouteNames.main),
            ),
          ],
        ),
      ),
    );
  }
}