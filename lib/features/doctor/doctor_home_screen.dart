import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/account_user.dart';
import '../../core/models/appointment.dart';
import '../../core/models/app_user_role.dart';
import '../../core/widgets/hn_bottom_nav.dart';
import '../appointments/data/appointments_api.dart';
import '../hospitals/data/hospitals_api.dart';
import '../menu/menu_screen.dart';
import '../notifications/data/notifications_api.dart';
import '../notifications/notifications_screen.dart';
import 'doctor_appointments_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  final AccountUser? user;

  const DoctorHomeScreen({super.key, this.user});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _idx = 0;
  int _unreadCount = 0;
  final _notificationsApi = NotificationsApi();

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notificationsApi.unreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {}
  }

  static const _navItems = [
    HnBottomNavItem(
      activeIcon: Icons.dashboard_rounded,
      inactiveIcon: Icons.dashboard_outlined,
      label: 'Panel',
    ),
    HnBottomNavItem(
      activeIcon: Icons.event_available_rounded,
      inactiveIcon: Icons.event_available_outlined,
      label: 'Randevular',
    ),
    HnBottomNavItem(
      activeIcon: Icons.notifications_rounded,
      inactiveIcon: Icons.notifications_none_rounded,
      label: 'Bildiri\u{015F}l\u{0259}r',
    ),
    HnBottomNavItem(
      activeIcon: Icons.menu_rounded,
      inactiveIcon: Icons.menu,
      label: 'Men\u{00FC}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PopScope(
        canPop: _idx == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _idx != 0) {
            setState(() => _idx = 0);
          }
        },
        child: Scaffold(
          backgroundColor: context.bgPage,
          body: IndexedStack(
            index: _idx,
            children: [
              _DoctorDashboard(
                user: widget.user,
                unreadCount: _unreadCount,
                onOpenAppointments: () => setState(() => _idx = 1),
                onOpenNotifications: () => setState(() => _idx = 2),
              ),
              const DoctorAppointmentsScreen(),
              const NotificationsScreen(role: AppUserRole.doctor),
              MenuScreen(
                user: widget.user,
                role: AppUserRole.doctor,
                onBack: () => setState(() => _idx = 0),
              ),
            ],
          ),
          bottomNavigationBar: HnBottomNav(
            currentIndex: _idx,
            onTap: (i) {
              final wasOnNotifications = _idx == 2;
              setState(() => _idx = i);
              if (wasOnNotifications) _loadUnreadCount();
            },
            items: _navItems,
          ),
        ),
      ),
    );
  }
}

class _DoctorDashboard extends StatefulWidget {
  final AccountUser? user;
  final int unreadCount;
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenNotifications;

  const _DoctorDashboard({
    this.user,
    required this.unreadCount,
    required this.onOpenAppointments,
    required this.onOpenNotifications,
  });

  @override
  State<_DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<_DoctorDashboard> {
  final _api = AppointmentsApi();
  final _hospitalsApi = HospitalsApi();
  late Future<DoctorDashboard> _future;
  late Future<HospitalDoctor> _profileFuture;

  @override
  void initState() {
    super.initState();
    _future = _api.doctorDashboard();
    _profileFuture = _hospitalsApi.doctorProfile();
  }

  Future<void> _reload() async {
    final future = _api.doctorDashboard();
    final profileFuture = _hospitalsApi.doctorProfile();
    setState(() {
      _future = future;
      _profileFuture = profileFuture;
    });
    try {
      await Future.wait([future, profileFuture]);
    } catch (_) {
      // The FutureBuilder below owns the visible error state.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DoctorDashboard>(
      future: _future,
      builder: (context, snapshot) {
        final dashboard = snapshot.data;
        final loading =
            snapshot.connectionState == ConnectionState.waiting &&
            dashboard == null;
        final error = snapshot.hasError ? context.tr('Xəta baş verdi') : null;

        return RefreshIndicator(
          onRefresh: _reload,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder<HospitalDoctor>(
                  future: _profileFuture,
                  builder: (context, profileSnapshot) => _Header(
                    user: widget.user,
                    doctor: profileSnapshot.data,
                    unreadCount: widget.unreadCount,
                    onOpenNotifications: widget.onOpenNotifications,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _TodayStats(dashboard: dashboard, loading: loading),
              ),
              SliverToBoxAdapter(
                child: _QuickActions(
                  onOpenAppointments: widget.onOpenAppointments,
                ),
              ),
              SliverToBoxAdapter(
                child: _TodayQueue(
                  items: dashboard?.todayAppointments ?? const [],
                  loading: loading,
                  error: error,
                  onRetry: _reload,
                  onOpenAppointments: widget.onOpenAppointments,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final AccountUser? user;
  final HospitalDoctor? doctor;
  final int unreadCount;
  final VoidCallback onOpenNotifications;

  const _Header({
    this.user,
    this.doctor,
    required this.unreadCount,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: context.headerGradientColors,
        ),
      ),
      padding: EdgeInsets.fromLTRB(24, top + 20, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                context.tr('Həkim paneli'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onOpenNotifications,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white.withValues(alpha: 0.76),
                        size: 20,
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -3,
                        child: Container(
                          width: 17,
                          height: 17,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            context.tr('Xoş gəldiniz'),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8FAAC7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            doctor?.name.isNotEmpty == true
                ? doctor!.name
                : user == null
                ? 'Dr. Həkim'
                : 'Dr. ${user!.fullName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Text(
              '${doctor?.specialty.isNotEmpty == true ? doctor!.specialty : context.tr('Həkim')}  •  ${doctor?.hospitalName.isNotEmpty == true ? doctor!.hospitalName : context.tr('Xəstəxana')}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFBFD7F8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayStats extends StatelessWidget {
  final DoctorDashboard? dashboard;
  final bool loading;

  const _TodayStats({required this.dashboard, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _MetricCard(
              value: loading ? '-' : '${dashboard?.today ?? 0}',
              label: 'Bu gün qəbul',
              icon: Icons.people_alt_outlined,
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MetricCard(
              value: loading ? '-' : '${dashboard?.pending ?? 0}',
              label: 'Yeni randevu',
              icon: Icons.mark_unread_chat_alt_outlined,
              color: AppColors.danger,
              bg: AppColors.dangerLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onOpenAppointments;

  const _QuickActions({required this.onOpenAppointments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: _ActionTile(
              icon: Icons.event_available_outlined,
              title: 'Randevular',
              subtitle: 'Qəbul siyahısı',
              color: AppColors.primary,
              bg: AppColors.primaryLight,
              onTap: onOpenAppointments,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayQueue extends StatelessWidget {
  final List<Appointment> items;
  final bool loading;
  final String? error;
  final Future<void> Function() onRetry;
  final VoidCallback onOpenAppointments;

  const _TodayQueue({
    required this.items,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onOpenAppointments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Bugünkü randevular'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOpenAppointments,
                child: Text(
                  context.tr('Hamısı'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Text(
                    error!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onRetry,
                    child: Text(context.tr('Yenidən cəhd et')),
                  ),
                ],
              ),
            )
          else if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Text(
                context.tr('Bu gün üçün randevu yoxdur'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            ...items.map((item) {
              final waiting = item.status == 'pending';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.bgSubtle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.formattedTime,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.citizenName.isEmpty ? '-' : item.citizenName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.tr(item.displayStatus),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: waiting
                                  ? AppColors.amber
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 25,
                      color: AppColors.textDimmed,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.tr(label),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: context.textSubColor,
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 23),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr(title),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.tr(subtitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
