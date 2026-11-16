import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/models/order_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderModel order;
  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient, shape: BoxShape.circle,
                  boxShadow: AppColors.primaryShadow,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 28),
              Text('Order Placed!', style: AppTextStyles.displaySmall)
                  .animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
              const SizedBox(height: 10),
              Text('Your order ${Formatters.orderNo(order.id)} has been confirmed.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center)
                  .animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
              _InfoCard(order: order).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              if (order.loyaltyEarned > 0) ...[
                const SizedBox(height: 16),
                _PointsBanner(points: order.loyaltyEarned).animate().fadeIn(delay: 500.ms),
              ],
              const Spacer(),
              AppButton(
                label: 'Track Order',
                onPressed: () => context.go(RouteNames.orderTracking, extra: order),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back to Home',
                variant: AppButtonVariant.ghost,
                onPressed: () => context.go(RouteNames.main),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final OrderModel order;
  const _InfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadows,
      ),
      child: Column(
        children: [
          _Row(Icons.access_time_rounded, 'Estimated Time', Formatters.minutesToReady(order.estimatedMinutes)),
          const Divider(height: 24),
          _Row(Icons.location_on_outlined, 'Delivering to', order.deliveryAddress.shortAddress),
          const Divider(height: 24),
          _Row(Icons.receipt_long_outlined, 'Total Paid', order.total.toCurrency),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  const _Row(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _PointsBanner extends StatelessWidget {
  final int points;
  const _PointsBanner({required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Text('You earned +$points loyalty points!',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}