import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';
import '../appointments/appointments_screen.dart';
import '../auth/login_screen.dart';
import 'haqqinda_screen.dart';
import 'melumatlarim_screen.dart';
import 'parametrler_screen.dart';

class MenuScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const MenuScreen({super.key, this.onBack});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isNavigating = false;

  Future<void> _openRoute(Widget screen) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } finally {
      if (mounted) _isNavigating = false;
    }
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildProfileCard(context),
              const SizedBox(height: 12),
              _buildMenuItems(context),
              const SizedBox(height: 12),
              _buildLogout(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF040E1C), Color(0xFF0D2240)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        26,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _handleBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF132D54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.tr('Profil'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF132D54),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0C0B1829),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'MG',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mahammad Gardaşov',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1829),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'FIN: 5MK2839 · AZE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7D93AB),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: Color(0xFF0B7A4A),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      context.tr('Təsdiqləndi'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0B7A4A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF1B4FD8),
            iconBg: const Color(0xFFEFF6FF),
            title: context.tr('Məlumatlarım'),
            subtitle: context.tr('Ad, soyad, əlaqə'),
            onTap: () => _openRoute(const MelumatlarimScreen()),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF1B4FD8),
            iconBg: const Color(0xFFEFF6FF),
            title: context.tr('Növbələrim'),
            subtitle: context.tr('Keçmiş və aktiv növbələr'),
            badge: '2',
            onTap: () => _openRoute(const AppointmentsScreen()),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFF7D93AB),
            iconBg: const Color(0xFFF5F8FF),
            title: context.tr('Parametrlər'),
            subtitle: context.tr('Dil, tema, bildirişlər'),
            onTap: () => _openRoute(const ParametrlerScreen()),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF7D93AB),
            iconBg: const Color(0xFFF5F8FF),
            title: context.tr('Haqqında'),
            subtitle: context.tr('Versiya, lisenziya'),
            onTap: () => _openRoute(const HaqqindaScreen()),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFD42B2B),
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('Çıxış etmək istəyirsiniz?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B1829),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(
                  'Hesabdan çıxdıqdan sonra yenidən\nMyGov ilə daxil olmaq lazım olacaq.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D93AB),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFD42B2B), Color(0xFFB91C1C)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      context.tr('Bəli, Çıxış Et'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    context.tr('Ləğv Et'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C4159),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFDDDD)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFD42B2B),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                context.tr('Çıxış Et'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD42B2B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFD42B2B),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B1829),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D93AB),
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4FD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD8E5),
              size: 26,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 78),
      height: 0.5,
      color: const Color(0xFFE8EFF8),
    );
  }
}
