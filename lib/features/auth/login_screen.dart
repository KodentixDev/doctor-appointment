import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF040E1C),
      body: Column(
        children: [
          // ── Top Section ─────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF040E1C),
                    Color(0xFF091F3C),
                    Color(0xFF0D2A50),
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    // Language selector — top-right
                    Positioned(
                      top: 12,
                      right: 20,
                      child: _LanguageSelector(),
                    ),
                    // Centered content
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF1B4FD8),
                                  Color(0xFF2563EB),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x441B4FD8),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.medical_services_rounded,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                          const SizedBox(height: 22),
                          // App name
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                height: 1,
                              ),
                              children: [
                                TextSpan(
                                  text: context.tr('Həkim'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: context.tr('Növbə'),
                                  style: const TextStyle(
                                    color: Color(0xFF60A5FA),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Subtitle
                          Text(
                            context.tr(
                              'Dövlət portalı vasitəsilə\ntəhlükəsiz daxil olun',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A7090),
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Bottom Sheet ────────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              top: 32,
              bottom: bottomPadding + 28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // MyGov login button
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x331B4FD8),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.tr('MyGov ilə Daxil Ol'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  context.tr('v2.4.0 · Səhiyyə Nazirliyi © 2026'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9AABBB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selected = context.language;

    return PopupMenuButton<AppLanguage>(
      initialValue: selected,
      onSelected: context.languageController.setLanguage,
      color: Colors.white,
      itemBuilder: (context) => AppLanguage.values
          .map(
            (language) => PopupMenuItem(
              value: language,
              child: Text(language.label),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              selected.code,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
