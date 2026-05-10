import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/models/account_user.dart';
import '../../core/models/app_user_role.dart';
import '../auth/data/accounts_api.dart';
import '../appointments/appointments_screen.dart';
import '../auth/login_screen.dart';
import '../doctor/doctor_appointments_screen.dart';
import '../messages/messages_screen.dart';
import '../notifications/notifications_screen.dart';
import '../requests/requests_screen.dart';
import 'haqqinda_screen.dart';
import 'melumatlarim_screen.dart';
import 'parametrler_screen.dart';

class MenuScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final AppUserRole role;
  final AccountUser? user;

  const MenuScreen({
    super.key,
    this.onBack,
    this.role = AppUserRole.patient,
    this.user,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isNavigating = false;
  final _accountsApi = AccountsApi();

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
        backgroundColor: AppColors.bgPage,
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
          colors: AppColors.headerGradient,
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
                color: AppColors.surface600,
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
              color: AppColors.surface600,
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
    final isDoctor = widget.role == AppUserRole.doctor;
    final initials = widget.user?.initials ?? (isDoctor ? 'NA' : 'HN');
    final fullName = widget.user == null
        ? (isDoctor ? 'Dr. Nigar Abbasova' : context.tr('Vətəndaş'))
        : isDoctor
            ? 'Dr. ${widget.user!.fullName}'
            : widget.user!.fullName;
    final info = isDoctor
        ? 'Kardioloq  •  Lisenziya: HN-20481'
        : 'FIN: ${widget.user?.finCode ?? '-'}  •  AZE';
    final status = isDoctor
        ? 'H\u{0259}kim hesab\u{0131} t\u{0259}sdiql\u{0259}nib'
        : 'T\u{0259}sdiql\u{0259}nib';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                colors: AppColors.primaryGradient,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
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
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  info,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        context.tr(status),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
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
    final isDoctor = widget.role == AppUserRole.doctor;

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
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: context.tr('M\u{0259}lumatlar\u{0131}m'),
            subtitle: context.tr(
              isDoctor
                  ? 'H\u{0259}kim profili v\u{0259} \u{0259}laq\u{0259}'
                  : 'Ad, soyad, \u{0259}laq\u{0259}',
            ),
            onTap: () => _openRoute(MelumatlarimScreen(user: widget.user)),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.calendar_today_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: context.tr(isDoctor ? 'Randevular' : 'N\u{00F6}vb\u{0259}l\u{0259}rim'),
            subtitle: context.tr(
              isDoctor
                  ? 'Sizin q\u{0259}bulunuza yaz\u{0131}lanlar'
                  : 'Ke\u{00E7}mi\u{015F} v\u{0259} aktiv n\u{00F6}vb\u{0259}l\u{0259}r',
            ),
            badge: isDoctor ? '6' : '2',
            onTap: () => _openRoute(
              isDoctor
                  ? const DoctorAppointmentsScreen()
                  : const AppointmentsScreen(),
            ),
          ),
          if (!isDoctor) ...[
            const _Divider(),
            _MenuItem(
              icon: Icons.assignment_outlined,
              iconColor: AppColors.amber,
              iconBg: AppColors.amberLight,
              title: context.tr('T\u{0259}l\u{0259}bl\u{0259}r'),
              subtitle: context.tr('M\u{00FC}raci\u{0259}t v\u{0259} sor\u{011F}ular'),
              onTap: () => _openRoute(const RequestsScreen()),
            ),
          ],
          const _Divider(),
          _MenuItem(
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: AppColors.success,
            iconBg: AppColors.successLight,
            title: context.tr('Mesajlar'),
            subtitle: context.tr(
              isDoctor
                  ? 'Pasiyentl\u{0259}rl\u{0259} yaz\u{0131}\u{015F}malar'
                  : 'H\u{0259}kiml\u{0259}rl\u{0259} yaz\u{0131}\u{015F}malar',
            ),
            badge: isDoctor ? '4' : '2',
            onTap: () => _openRoute(MessagesScreen(role: widget.role)),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.notifications_none_rounded,
            iconColor: AppColors.danger,
            iconBg: AppColors.dangerLight,
            title: context.tr('Bildiri\u{015F}l\u{0259}r'),
            subtitle: context.tr('X\u{0259}b\u{0259}rdarl\u{0131}qlar v\u{0259} xat\u{0131}rlatmalar'),
            badge: '2',
            onTap: () => _openRoute(NotificationsScreen(role: widget.role)),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.settings_outlined,
            iconColor: AppColors.textMuted,
            iconBg: AppColors.bgSubtle,
            title: context.tr('Parametrl\u{0259}r'),
            subtitle: context.tr('Dil, tema, bildiri\u{015F}l\u{0259}r'),
            onTap: () => _openRoute(const ParametrlerScreen()),
          ),
          const _Divider(),
          _MenuItem(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.textMuted,
            iconBg: AppColors.bgSubtle,
            title: context.tr('Haqq\u{0131}nda'),
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
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('\u{00C7}\u{0131}x\u{0131}\u{015F} etm\u{0259}k ist\u{0259}yirsiniz?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(
                  'Hesabdan \u{00E7}\u{0131}xd\u{0131}qdan sonra yenid\u{0259}n daxil olmaq laz\u{0131}m olacaq.',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
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
                      colors: AppColors.dangerGradient,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await _accountsApi.logout();
                      } catch (_) {
                        await _accountsApi.clearSession();
                      }
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      );
                    },
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
                      context.tr('B\u{0259}li, \u{00E7}\u{0131}x\u{0131}\u{015F} et'),
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
                    backgroundColor: AppColors.bgSubtle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    context.tr('L\u{0259}\u{011F}v et'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSub,
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
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.danger,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                context.tr('\u{00C7}\u{0131}x\u{0131}\u{015F} et'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.danger,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.danger,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
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
                  color: AppColors.primary,
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
              color: AppColors.textDimmed,
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
      color: AppColors.border,
    );
  }
}
