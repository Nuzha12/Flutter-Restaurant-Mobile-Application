import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

extension StringExt on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String get titleCase =>
      split(' ').map((w) => w.capitalize).join(' ');
  String get initials =>
      split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
  bool get isValidEmail =>
      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(this);
}

extension DoubleExt on double {
  String get toCurrency => '${AppConstants.currencySymbol}${toStringAsFixed(2)}';
  String get toShortCurrency {
    if (this >= 1000) {
      return '${AppConstants.currencySymbol}${(this / 1000).toStringAsFixed(1)}k';
    }
    return toCurrency;
  }
}

extension IntExt on int {
  String get toCurrency => toDouble().toCurrency;
  String get toMinutes  => '$this ${AppConstants.timeUnit}';
  String get toKm       => '$this ${AppConstants.distanceUnit}';
}

extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return year == y.year && month == y.month && day == y.day;
  }
}

extension ContextExt on BuildContext {
  ThemeData   get theme       => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size        get screenSize  => MediaQuery.sizeOf(this);
  double      get screenW     => MediaQuery.sizeOf(this).width;
  double      get screenH     => MediaQuery.sizeOf(this).height;
  EdgeInsets  get viewPadding => MediaQuery.viewPaddingOf(this);
  bool        get isSmall     => MediaQuery.sizeOf(this).width < 360;

  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // Primary name used in new code
  void showSnack(String message, {bool isError = false, IconData? icon}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.textPrimary,
        behavior:        SnackBarBehavior.floating,
        margin:          const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Alias kept for backward compatibility with older screens
  void showSnackBar(String message, {bool isError = false}) =>
      showSnack(message, isError: isError);

  Future<T?> showAppBottomSheet<T>(
      Widget child, {
        bool isScrollControlled = true,
      }) {
    return showModalBottomSheet<T>(
      context:             this,
      isScrollControlled:  isScrollControlled,
      backgroundColor:     Colors.transparent,
      builder:             (_) => child,
    );
  }
}

extension WidgetExt on Widget {
  Widget get sliver => SliverToBoxAdapter(child: this);

  Widget paddingAll(double v) =>
      Padding(padding: EdgeInsets.all(v), child: this);

  Widget paddingH(double v) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: v), child: this);

  Widget paddingV(double v) =>
      Padding(padding: EdgeInsets.symmetric(vertical: v), child: this);

  Widget paddingOnly({
    double l = 0, double t = 0, double r = 0, double b = 0,
  }) =>
      Padding(padding: EdgeInsets.fromLTRB(l, t, r, b), child: this);
}