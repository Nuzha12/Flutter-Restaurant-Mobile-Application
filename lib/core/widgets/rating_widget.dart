import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int    reviewCount;
  final double size;
  final bool   showCount;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.size        = 13,
    this.showCount   = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.gold, size: size + 3),
        const SizedBox(width: 3),
        Text(rating.toStringAsFixed(1),
            style: AppTextStyles.labelMedium.copyWith(fontSize: size)),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 2),
          Text('(${_format(reviewCount)})',
              style: AppTextStyles.caption.copyWith(fontSize: size - 1)),
        ],
      ],
    );
  }

  String _format(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class StarRow extends StatelessWidget {
  final double rating;
  final int    max;
  final double size;

  const StarRow({super.key, required this.rating, this.max = 5, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final filled = i < rating.floor();
        final partial = !filled && i < rating;
        return Icon(
          filled ? Icons.star_rounded : partial ? Icons.star_half_rounded : Icons.star_outline_rounded,
          color: AppColors.gold, size: size,
        );
      }),
    );
  }
}