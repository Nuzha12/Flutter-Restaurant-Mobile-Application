import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal, deliveryFee, tax, total;
  final double discount;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    this.discount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 14),
          _Row('Subtotal',   subtotal.toCurrency),
          const SizedBox(height: 8),
          _Row('Delivery',   deliveryFee == 0 ? 'Free 🎉' : deliveryFee.toCurrency,
              valueColor: deliveryFee == 0 ? AppColors.success : null),
          const SizedBox(height: 8),
          _Row('Tax (${(AppConstants.taxRate * 100).toInt()}%)', tax.toCurrency),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _Row('Discount', '- ${discount.toCurrency}', valueColor: AppColors.success),
          ],
          const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider()),
          _Row('Total', total.toCurrency, isTotal: true),
          if (subtotal < AppConstants.freeDeliveryThreshold && deliveryFee > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add ${(AppConstants.freeDeliveryThreshold - subtotal).toCurrency} more for free delivery',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool   isTotal;
  final Color? valueColor;
  const _Row(this.label, this.value, {this.isTotal = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isTotal ? AppTextStyles.headlineSmall : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(value,  style: isTotal ? AppTextStyles.price : AppTextStyles.bodyMedium.copyWith(color: valueColor ?? AppColors.textPrimary)),
      ],
    );
  }
}