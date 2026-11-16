import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppCachedImage extends StatelessWidget {
  final String  url;
  final double? width;
  final double? height;
  final BoxFit  fit;
  final double  radius;
  final Widget? placeholder;

  const AppCachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit         = BoxFit.cover,
    this.radius      = 0,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final img = CachedNetworkImage(
      imageUrl: url,
      width:    width,
      height:   height,
      fit:      fit,
      placeholder: (_, __) =>
      placeholder ??
          Container(
            width:  width,
            height: height,
            color:  AppColors.shimmerBase,
          ),
      errorWidget: (_, __, ___) => Container(
        width:  width,
        height: height,
        color:  AppColors.surfaceVariant,
        child:  const Icon(
          Icons.broken_image_outlined,
          color: AppColors.textHint,
        ),
      ),
    );

    if (radius == 0) return img;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: img,
    );
  }
}