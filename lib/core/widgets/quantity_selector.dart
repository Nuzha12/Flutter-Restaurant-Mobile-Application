import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class QuantitySelector extends StatelessWidget {
  final int          quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int          min;
  final int          max;
  final double       size;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.min  = 1,
    this.max  = 20,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(size / 2 + 4),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn(icon: Icons.remove, onTap: onDecrement, enabled: quantity > min, size: size),
          SizedBox(
            width: size,
            child: Text('$quantity',
                style: AppTextStyles.headlineSmall.copyWith(fontSize: size * 0.44),
                textAlign: TextAlign.center),
          ),
          _Btn(icon: Icons.add, onTap: onIncrement, enabled: quantity < max, size: size),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final double size;

  const _Btn({required this.icon, required this.onTap, required this.enabled, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size, height: size,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}