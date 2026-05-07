import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle screenTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
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
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
  static const TextStyle overline = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.textMuted,
    letterSpacing: 0.8,
  );
  static const TextStyle btnLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.1,
  );
  static const TextStyle whiteTitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.3,
  );
  static const TextStyle whiteSub = TextStyle(
    fontSize: 11,
    color: Color(0x993A5070),
  );
}
