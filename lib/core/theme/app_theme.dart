import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Controller ────────────────────────────────────────────────────────────────

class AppThemeController extends ChangeNotifier {
  static const _prefsKey = 'app_theme_dark';

  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_prefsKey) ?? false;
  }

  void setDark(bool value) {
    if (_isDark == value) return;
    _isDark = value;
    unawaited(_save(value));
    notifyListeners();
  }

  Future<void> _save(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}

// ── Scope ─────────────────────────────────────────────────────────────────────

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppThemeController controllerOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(scope != null, 'AppThemeScope not found above this context.');
    return scope!.notifier!;
  }

  static bool isDarkOf(BuildContext context) =>
      controllerOf(context).isDark;
}

// ── BuildContext extension ────────────────────────────────────────────────────

extension AppThemeX on BuildContext {
  AppThemeController get themeController => AppThemeScope.controllerOf(this);
  bool get isDark => AppThemeScope.isDarkOf(this);
}

// ── Theme data ────────────────────────────────────────────────────────────────

class HnTheme {
  HnTheme._();

  static ThemeData get light => ThemeData(
    fontFamily: 'SF Pro Display',
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F5FF),
    cardColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1B4FD8),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );

  static ThemeData get dark => ThemeData(
    fontFamily: 'SF Pro Display',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    cardColor: const Color(0xFF1C2128),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1B4FD8),
      brightness: Brightness.dark,
    ).copyWith(
      surface: const Color(0xFF161B22),
      onSurface: const Color(0xFFF0F6FC),
    ),
    useMaterial3: true,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}

// ── Dynamic color extension ───────────────────────────────────────────────────

extension HnColors on BuildContext {
  bool get _dark => isDark;

  // Backgrounds
  Color get bgPage =>
      _dark ? const Color(0xFF0D1117) : const Color(0xFFF0F5FF);
  Color get bgCard => _dark ? const Color(0xFF1C2128) : Colors.white;
  Color get bgSubtle =>
      _dark ? const Color(0xFF161B22) : const Color(0xFFF5F8FF);

  // Text
  Color get textPrimaryColor =>
      _dark ? const Color(0xFFF0F6FC) : const Color(0xFF0B1829);
  Color get textSubColor =>
      _dark ? const Color(0xFFCDD9E5) : const Color(0xFF2C4159);
  Color get textMutedColor =>
      _dark ? const Color(0xFF8B949E) : const Color(0xFF7D93AB);
  Color get textDimmedColor =>
      _dark ? const Color(0xFF484F58) : const Color(0xFFCBD8E5);

  // Borders
  Color get borderColor =>
      _dark ? const Color(0xFF30363D) : const Color(0xFFE8EFF8);
  Color get borderMidColor =>
      _dark ? const Color(0xFF21262D) : const Color(0xFFD8E4F0);

  // Header gradient
  List<Color> get headerGradientColors => _dark
      ? [const Color(0xFF0D1117), const Color(0xFF161B22)]
      : [const Color(0xFF040E1C), const Color(0xFF0D2240)];

  // Surface containers
  Color get surface600 =>
      _dark ? const Color(0xFF21262D) : const Color(0xFF132D54);
}
