import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 36, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 22, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineLarge => GoogleFonts.dmSans(
    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => GoogleFonts.dmSans(
    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );

  static TextStyle get headlineSmall => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
  );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.3,
  );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
    fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
    fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5,
  );

  static TextStyle get price => GoogleFonts.dmSans(
    fontSize: 20, fontWeight: FontWeight.w800,
    color: AppColors.primary, letterSpacing: -0.3,
  );

  static TextStyle get priceSmall => GoogleFonts.dmSans(
    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary,
  );

  static TextStyle get priceLarge => GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textHint,
    letterSpacing: 0.2,
  );

  static TextStyle get badge => GoogleFonts.dmSans(
    fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3,
  );
}