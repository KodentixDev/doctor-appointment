import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/app_user_role.dart';
import '../../core/widgets/hn_bottom_nav.dart';
import '../menu/menu_screen.dart';
import '../messages/messages_screen.dart';
import '../notifications/notifications_screen.dart';
import 'doctor_appointments_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _idx = 0;

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
      activeIcon: Icons.chat_bubble_rounded,
      inactiveIcon: Icons.chat_bubble_outline_rounded,
      label: 'Mesajlar',
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
          backgroundColor: AppColors.bgPage,
          body: IndexedStack(
            index: _idx,
            children: [
              _DoctorDashboard(
                onOpenAppointments: () => setState(() => _idx = 1),
                onOpenMessages: () => setState(() => _idx = 2),
                onOpenNotifications: () => setState(() => _idx = 3),
              ),
              const DoctorAppointmentsScreen(),
              const MessagesScreen(role: AppUserRole.doctor),
              const NotificationsScreen(role: AppUserRole.doctor),
              MenuScreen(
                role: AppUserRole.doctor,
                onBack: () => setState(() => _idx = 0),
              ),
            ],
          ),
          bottomNavigationBar: HnBottomNav(
            currentIndex: _idx,
            onTap: (i) => setState(() => _idx = i),
            items: _navItems,
          ),
        ),
      ),
    );
  }
}

class _DoctorDashboard extends StatelessWidget {
  final VoidCallback onOpenAppointments;
  final VoidCallback onOpenMessages;
  final VoidCallback onOpenNotifications;

  const _DoctorDashboard({
    required this.onOpenAppointments,
    required this.onOpenMessages,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(onOpenNotifications: onOpenNotifications),
        ),
        SliverToBoxAdapter(child: _TodayStats()),
        SliverToBoxAdapter(
          child: _QuickActions(
            onOpenAppointments: onOpenAppointments,
            onOpenMessages: onOpenMessages,
          ),
        ),
        SliverToBoxAdapter(
          child: _TodayQueue(onOpenAppointments: onOpenAppointments),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onOpenNotifications;

  const _Header({required this.onOpenNotifications});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
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
              const Text(
                'H\u{0259}kim Paneli',
                style: TextStyle(
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
                        child: const Text(
                          '2',
                          style: TextStyle(
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
          const Text(
            'Xo\u{015F} g\u{0259}ldiniz',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8FAAC7),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Dr. Nigar Abbasova',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
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
            child: const Text(
              'Kardioloq  •  Bak\u{0131} \u{015E}\u{0259}h\u{0259}r Klinik X\u{0259}st\u{0259}xanas\u{0131}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: const [
          Expanded(
            child: _MetricCard(
              value: '6',
              label: 'Bu g\u{00FC}n q\u{0259}bul',
              icon: Icons.people_alt_outlined,
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _MetricCard(
              value: '2',
              label: 'Yeni mesaj',
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
  final VoidCallback onOpenMessages;

  const _QuickActions({
    required this.onOpenAppointments,
    required this.onOpenMessages,
  });

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
              subtitle: 'Q\u{0259}bul siyah\u{0131}s\u{0131}',
              color: AppColors.primary,
              bg: AppColors.primaryLight,
              onTap: onOpenAppointments,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Mesajlar',
              subtitle: 'Pasiyent suallar\u{0131}',
              color: AppColors.success,
              bg: AppColors.successLight,
              onTap: onOpenMessages,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayQueue extends StatelessWidget {
  final VoidCallback onOpenAppointments;

  const _TodayQueue({required this.onOpenAppointments});

  static const _items = [
    ('09:30', 'M\u{0259}h\u{0259}mm\u{0259}d Qarda\u{015F}ov', 'T\u{0259}sdiql\u{0259}ndi'),
    ('11:00', 'S\u{0259}bin\u{0259} Al\u{0131}yeva', 'G\u{00F6}zl\u{0259}nilir'),
    ('13:45', 'R\u{0259}na M\u{0259}mm\u{0259}dli', 'T\u{0259}sdiql\u{0259}ndi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Bug\u{00FC}nk\u{00FC} randevular',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onOpenAppointments,
                child: const Text(
                  'Ham\u{0131}s\u{0131}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._items.map((item) {
            final waiting = item.$3 == 'G\u{00F6}zl\u{0259}nilir';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
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
                      item.$1,
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
                          item.$2,
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
                          item.$3,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: waiting ? AppColors.amber : AppColors.success,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
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
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSub,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
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
              title,
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
              subtitle,
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
