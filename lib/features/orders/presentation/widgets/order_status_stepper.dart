import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../domain/models/order_model.dart';

class OrderStatusStepper extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusStepper({super.key, required this.status});

  static const _steps = [
    (status: OrderStatus.confirmed, label: 'Confirmed', icon: Icons.check_circle_outline),
    (status: OrderStatus.preparing, label: 'Preparing', icon: Icons.restaurant_rounded),
    (status: OrderStatus.outForDelivery, label: 'On the way', icon: Icons.delivery_dining_rounded),
    (status: OrderStatus.delivered, label: 'Delivered', icon: Icons.home_rounded),
  ];

  int get _currentStep => _steps.indexWhere((s) => s.status == status);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = _currentStep > i ~/ 2;
          return Expanded(
            child: Container(
              height: 2,
              color: done ? AppColors.primary : AppColors.divider,
            ),
          );
        }
        final stepIdx = i ~/ 2;
        final step = _steps[stepIdx];
        final isDone = _currentStep >= stepIdx;
        return Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(step.icon,
                  color: isDone ? Colors.white : AppColors.textHint, size: 20),
            ),
            const SizedBox(height: 6),
            Text(step.label,
                style: AppTextStyles.labelMedium.copyWith(
                    color: isDone ? AppColors.primary : AppColors.textHint,
                    fontSize: 10),
                textAlign: TextAlign.center),
          ],
        );
      }),
    );
  }
}