import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }
enum AppButtonSize     { small, medium, large }

class AppButton extends StatelessWidget {
  final String          label;
  final VoidCallback?   onPressed;
  final AppButtonVariant variant;
  final AppButtonSize    size;
  final bool            isLoading;
  final IconData?       prefixIcon;
  final IconData?       suffixIcon;
  final double?         width;
  final Gradient?       gradient;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant  = AppButtonVariant.primary,
    this.size     = AppButtonSize.medium,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.gradient,
  });

  double get _height {
    switch (size) {
      case AppButtonSize.small:  return 40;
      case AppButtonSize.medium: return 54;
      case AppButtonSize.large:  return 60;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.small:  return AppTextStyles.labelMedium;
      case AppButtonSize.medium: return AppTextStyles.labelLarge;
      case AppButtonSize.large:  return AppTextStyles.labelLarge.copyWith(fontSize: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (variant == AppButtonVariant.primary && gradient != null) {
      return _GradientButton(
        label: label, onPressed: onPressed, isLoading: isLoading,
        height: _height, width: width, gradient: gradient!,
        textStyle: _textStyle, prefixIcon: prefixIcon,
      );
    }

    Widget content = isLoading
        ? SizedBox(
      width: 20, height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: variant == AppButtonVariant.outline || variant == AppButtonVariant.ghost
            ? AppColors.primary : Colors.white,
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[Icon(prefixIcon, size: 18), const SizedBox(width: 8)],
        Text(label, style: _textStyle),
        if (suffixIcon != null) ...[const SizedBox(width: 8), Icon(suffixIcon, size: 18)],
      ],
    );

    ButtonStyle? style;
    switch (variant) {
      case AppButtonVariant.secondary:
        style = ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary, foregroundColor: Colors.white,
          minimumSize: Size(width ?? double.infinity, _height),
        );
        return ElevatedButton(onPressed: isLoading ? null : onPressed, style: style, child: content);
      case AppButtonVariant.outline:
        return SizedBox(
          width: width ?? double.infinity, height: _height,
          child: OutlinedButton(onPressed: isLoading ? null : onPressed, child: content),
        );
      case AppButtonVariant.ghost:
        return SizedBox(
          width: width ?? double.infinity, height: _height,
          child: TextButton(onPressed: isLoading ? null : onPressed, child: content),
        );
      case AppButtonVariant.danger:
        style = ElevatedButton.styleFrom(
          backgroundColor: AppColors.error, foregroundColor: Colors.white,
          minimumSize: Size(width ?? double.infinity, _height),
        );
        return ElevatedButton(onPressed: isLoading ? null : onPressed, style: style, child: content);
      default:
        return SizedBox(
          width: width ?? double.infinity, height: _height,
          child: ElevatedButton(onPressed: isLoading ? null : onPressed, child: content),
        );
    }
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final Gradient gradient;
  final TextStyle textStyle;
  final IconData? prefixIcon;

  const _GradientButton({
    required this.label, required this.onPressed, required this.isLoading,
    required this.height, required this.gradient, required this.textStyle,
    this.width, this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.primaryShadow,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label, style: textStyle.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 100.ms, curve: Curves.easeOut);
  }
}