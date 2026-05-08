import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    letterSpacing: -0.8,
    height: 1.1,
  );

  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  static const TextStyle sub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.textMuted,
    letterSpacing: 1.1,
  );

  static const TextStyle btnLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
  );
}
