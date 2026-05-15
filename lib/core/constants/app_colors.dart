import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand Blues ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1B4FD8);
  static const Color primaryBright = Color(0xFF2563EB);
  static const Color primaryMid = Color(0xFF60A5FA);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryBorder = Color(0xFFBFD7F8);

  // ── Dark Surfaces (headers, nav) ─────────────────────────────────────────
  static const Color surface900 = Color(0xFF040E1C);
  static const Color surface800 = Color(0xFF081829);
  static const Color surface700 = Color(0xFF0D2240);
  static const Color surface600 = Color(0xFF132D54);

  // ── Light Surfaces ────────────────────────────────────────────────────────
  static const Color bgPage = Color(0xFFF0F5FF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgSubtle = Color(0xFFF5F8FF);
  static const Color bgDarkMid = Color(0xFF0D2240);
  static const Color bgDarkBorder = Color(0xFF183257);

  // ── Legacy compat ─────────────────────────────────────────────────────────
  static const Color bgDark = surface800;

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0B1829);
  static const Color textSub = Color(0xFF2C4159);
  static const Color textMuted = Color(0xFF7D93AB);
  static const Color textLight = Color(0xFFB0C3D4);
  static const Color textDimmed = Color(0xFFCBD8E5);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE8EFF8);
  static const Color borderMid = Color(0xFFD8E4F0);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color danger = Color(0xFFD42B2B);
  static const Color dangerLight = Color(0xFFFFECEC);
  static const Color success = Color(0xFF0B7A4A);
  static const Color successLight = Color(0xFFD6F5E8);
  static const Color successDark = Color(0xFF064029);
  static const Color amber = Color(0xFF9A5200);
  static const Color amberLight = Color(0xFFFEF0D6);

  // ── Nav ───────────────────────────────────────────────────────────────────
  static const Color navBg = surface800;

  // ── Gradients (as lists for LinearGradient) ───────────────────────────────
  static const List<Color> headerGradient = [surface900, surface700];
  static const List<Color> primaryGradient = [primary, primaryBright];
  static const List<Color> successGradient = [
    Color(0xFF0B7A4A),
    Color(0xFF0EA05F),
  ];
  static const List<Color> dangerGradient = [
    Color(0xFFB91C1C),
    Color(0xFFD42B2B),
  ];
}
