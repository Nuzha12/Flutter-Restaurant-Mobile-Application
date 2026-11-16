import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary        = Color(0xFFE63946);
  static const Color primaryDark    = Color(0xFFC1121F);
  static const Color primaryLight   = Color(0xFFFF6B6B);
  static const Color secondary      = Color(0xFFF4A261);
  static const Color accent         = Color(0xFF2A9D8F);
  static const Color gold           = Color(0xFFFFB703);

  static const Color background     = Color(0xFFF8F9FA);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  static const Color card           = Color(0xFFFFFFFF);

  static const Color textPrimary    = Color(0xFF1A1A2E);
  static const Color textSecondary  = Color(0xFF6C757D);
  static const Color textHint       = Color(0xFFADB5BD);
  static const Color textOnDark     = Color(0xFFFFFFFF);

  static const Color success        = Color(0xFF2DC653);
  static const Color warning        = Color(0xFFFFB703);
  static const Color error          = Color(0xFFE63946);
  static const Color info           = Color(0xFF4361EE);

  static const Color divider        = Color(0xFFE9ECEF);
  static const Color shadow         = Color(0x1A000000);
  static const Color cardShadow     = Color(0x0D000000);
  static const Color overlay        = Color(0x80000000);

  static const Color shimmerBase      = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xCC1A1A2E), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFE63946)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB703), Color(0xFFF4A261)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadows => [
    BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4,  offset: const Offset(0, 1)),
  ];

  static List<BoxShadow> get primaryShadow => [
    BoxShadow(color: primary.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}