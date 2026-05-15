import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/account_user.dart';
import '../../core/models/app_user_role.dart';
import '../../core/widgets/hn_bottom_nav.dart';
import '../appointments/appointments_screen.dart';
import '../booking/city_screen.dart';
import '../calendar/calendar_screen.dart';
import '../menu/menu_screen.dart';
import '../notifications/data/notifications_api.dart';
import '../notifications/notifications_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final AccountUser? user;

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Ana S\u{0259}hif\u{0259}',
    ),
    HnBottomNavItem(
      activeIcon: Icons.calendar_month_rounded,
      inactiveIcon: Icons.calendar_month_outlined,
      label: 'T\u{0259}qvim',
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
              _HomeBody(
                user: widget.user,
                unreadCount: _unreadCount,
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
                ),
                onOpenNotifications: () => setState(() => _idx = 2),
              ),
              const CalendarScreen(),
              const NotificationsScreen(role: AppUserRole.citizen),
              MenuScreen(
                user: widget.user,
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

// ── Home Body ────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  final AccountUser? user;
  final int unreadCount;
  final VoidCallback onViewAll;
  final VoidCallback onOpenNotifications;

  const _HomeBody({
    this.user,
    required this.unreadCount,
    required this.onViewAll,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _HeaderWithSearch(
            user: user,
            unreadCount: unreadCount,
            onOpenNotifications: onOpenNotifications,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
        SliverToBoxAdapter(child: _ServicesSection()),
        SliverToBoxAdapter(child: _UpcomingSection(onViewAll: onViewAll)),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

// ── Header + Search overlay ──────────────────────────────────────────────────

class _HeaderWithSearch extends StatelessWidget {
  final AccountUser? user;
  final int unreadCount;
  final VoidCallback onOpenNotifications;

  const _HeaderWithSearch({
    this.user,
    required this.unreadCount,
    required this.onOpenNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Header(
          user: user,
          unreadCount: unreadCount,
          onOpenNotifications: onOpenNotifications,
        ),
        Positioned(left: 20, right: 20, bottom: -26, child: _SearchBar()),
      ],
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AccountUser? user;
  final int unreadCount;
  final VoidCallback onOpenNotifications;

  const _Header({
    this.user,
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
      padding: EdgeInsets.fromLTRB(24, top + 20, 24, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo row ──────────────────────────────────────────────────────
          Row(
            children: [
              // Logo icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.medical_services_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              // App name
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    height: 1,
                  ),
                  children: [
                    TextSpan(
                      text: context.tr('Həkim '),
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: context.tr('Növbə'),
                      style: const TextStyle(color: Color(0xFF60A5FA)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Notification button
              GestureDetector(
                onTap: onOpenNotifications,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10),
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white.withValues(alpha: 0.70),
                        size: 20,
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -3,
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount > 9 ? '9+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // User avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  user?.initials ?? 'HN',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          // ── Welcome text ─────────────────────────────────────────────────
          Text(
            '${context.tr('Xoş gəldiniz')} 👋',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7090B0),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user?.fullName ?? context.tr('Vətəndaş'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      ),
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF1B4FD8).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.tr('Poliklinik, həkim, xəstəxana axtar...'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Services Section ─────────────────────────────────────────────────────────

class _ServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('NÖVBƏ AL'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          _ServiceCard(
            icon: Icons.group_outlined,
            iconGradient: const LinearGradient(
              colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
            ),
            iconColor: Colors.white,
            title: context.tr('Ailə Həkimindən'),
            subtitle: context.tr('Qeydiyyatda olduğunuz həkim'),
            onTap: () => _go(context),
          ),
          const SizedBox(height: 12),
          _ServiceCard(
            icon: Icons.local_hospital_outlined,
            iconGradient: const LinearGradient(
              colors: [Color(0xFFB91C1C), Color(0xFFD42B2B)],
            ),
            iconColor: Colors.white,
            title: context.tr('Xəstəxanadan'),
            subtitle: context.tr('Dövlət və özəl müəssisələr'),
            onTap: () => _go(context),
          ),
          const SizedBox(height: 12),
          _ServiceCard(
            icon: Icons.monitor_heart_outlined,
            iconGradient: const LinearGradient(
              colors: [Color(0xFF0B7A4A), Color(0xFF0EA05F)],
            ),
            iconColor: Colors.white,
            title: context.tr('Sağlam Həyat Mərkəzi'),
            subtitle: context.tr('Profilaktika xidmətləri'),
            onTap: () => _go(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _go(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CityScreen()),
    );
  }
}

// ── Service Card ─────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconGradient;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.iconGradient,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container with gradient
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: iconGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFDAE4F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Upcoming Section ─────────────────────────────────────────────────────────

class _UpcomingSection extends StatelessWidget {
  final VoidCallback onViewAll;

  const _UpcomingSection({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('Yaxınlaşan növbələrim'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  context.tr('Hamısı'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Empty state
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderMid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.event_busy_outlined,
                  color: AppColors.textDimmed,
                  size: 32,
                ),
                const SizedBox(height: 10),
                Text(
                  context.tr('Aktiv növbəniz yoxdur'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
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
