import 'package:flutter/material.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/app_user_role.dart';
import '../doctor/doctor_home_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppUserRole _selectedRole = AppUserRole.patient;

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _selectedRole == AppUserRole.doctor
            ? const DoctorHomeScreen()
            : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final roleLabel = _selectedRole == AppUserRole.doctor
        ? 'H\u{0259}kim olaraq daxil ol'
        : 'V\u{0259}t\u{0259}nda\u{015F} olaraq daxil ol';

    return Scaffold(
      backgroundColor: const Color(0xFF040E1C),
      body: Column(
        children: [
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
                    Positioned(
                      top: 12,
                      right: 20,
                      child: _LanguageSelector(),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                                height: 1,
                              ),
                              children: [
                                TextSpan(
                                  text: 'H\u{0259}kim',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'N\u{00F6}vb\u{0259}',
                                  style: TextStyle(color: Color(0xFF60A5FA)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            context.tr(
                              'Randevu, mesaj v\u{0259} bildiri\u{015F}l\u{0259}ri vahid hesabdan idar\u{0259} edin',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8FAAC7),
                              height: 1.6,
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
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 28,
              bottom: bottomPadding + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Hesab tipi'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1829),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        selected: _selectedRole == AppUserRole.patient,
                        icon: Icons.person_outline_rounded,
                        title: 'V\u{0259}t\u{0259}nda\u{015F}',
                        subtitle: 'N\u{00F6}vb\u{0259} al',
                        onTap: () => setState(
                          () => _selectedRole = AppUserRole.patient,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RoleCard(
                        selected: _selectedRole == AppUserRole.doctor,
                        icon: Icons.medical_information_outlined,
                        title: 'H\u{0259}kim',
                        subtitle: 'Q\u{0259}bullar\u{0131} idar\u{0259} et',
                        onTap: () => setState(
                          () => _selectedRole = AppUserRole.doctor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _login,
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
                        Flexible(
                          child: Text(
                            context.tr(roleLabel),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'v2.4.0  •  S\u{0259}hiyy\u{0259} Nazirliyi \u{00A9} 2026',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9AABBB),
                    ),
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

class _RoleCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF6FF) : const Color(0xFFF5F8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF1B4FD8) : const Color(0xFFE8EFF8),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? const Color(0xFF1B4FD8)
                      : const Color(0xFF7D93AB),
                  size: 24,
                ),
                const Spacer(),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? const Color(0xFF1B4FD8)
                      : const Color(0xFFCBD8E5),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              context.tr(title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0B1829),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              context.tr(subtitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7D93AB),
              ),
            ),
          ],
        ),
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
