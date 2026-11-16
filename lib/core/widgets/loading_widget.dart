import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 2.5,
    ),
  );
}

class ShimmerBox extends StatelessWidget {
  final double  height;
  final double? width;
  final double  radius;

  const ShimmerBox({
    super.key,
    this.height = 120,
    this.width,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor:      AppColors.shimmerBase,
    highlightColor: AppColors.shimmerHighlight,
    child: Container(
      height: height,
      width:  width ?? double.infinity,
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

class ShimmerMenuGrid extends StatelessWidget {
  const ShimmerMenuGrid({super.key});

  @override
  Widget build(BuildContext context) => GridView.builder(
    physics:  const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount:  2,
      childAspectRatio: 0.72,
      crossAxisSpacing: 12,
      mainAxisSpacing:  12,
    ),
    itemCount:   6,
    itemBuilder: (_, __) => const ShimmerBox(height: 220),
  );
}

class ShimmerList extends StatelessWidget {
  final int count;
  const ShimmerList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) => ListView.separated(
    physics:    const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    padding:    const EdgeInsets.all(16),
    itemCount:  count,
    separatorBuilder: (_, __) => const SizedBox(height: 12),
    itemBuilder:      (_, __) => const ShimmerBox(height: 100),
  );
}