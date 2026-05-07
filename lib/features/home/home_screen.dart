import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/hn_bottom_nav.dart';
import '../appointments/appointments_screen.dart';
import '../booking/city_screen.dart';
import '../calendar/calendar_screen.dart';
import '../menu/menu_screen.dart';
import '../requests/requests_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

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
          backgroundColor: const Color(0xFFF1F4F8),
          body: IndexedStack(
            index: _idx,
            children: [
              _HomeBody(
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppointmentsScreen()),
                ),
              ),
              const CalendarScreen(),
              const RequestsScreen(),
              MenuScreen(onBack: () => setState(() => _idx = 0)),
            ],
          ),
          bottomNavigationBar: HnBottomNav(
            currentIndex: _idx,
            onTap: (i) => setState(() => _idx = i),
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final VoidCallback onViewAll;

  const _HomeBody({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _HeaderWithSearch()),
        const SliverToBoxAdapter(child: SizedBox(height: 30)),
        SliverToBoxAdapter(child: _ServicesSection()),
        SliverToBoxAdapter(child: _UpcomingSection(onViewAll: onViewAll)),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}

class _HeaderWithSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Header(),
        Positioned(
          left: 23,
          right: 23,
          bottom: -21,
          child: _SearchBar(),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: const Color(0xFF071427),
      padding: EdgeInsets.fromLTRB(24, top + 31, 24, 59),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF102C5F).withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: const Color(0xFF214A88)),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Color(0xFF3E86FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                  children: [
                    TextSpan(
                      text: 'Həkim ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'Növbə',
                      style: TextStyle(color: Color(0xFF4C8EF7)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _HeaderButton(icon: Icons.notifications_none_rounded),
              const SizedBox(width: 10),
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B3A51),
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'MG',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          const Text(
            'Xoş gəldiniz 👋',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF48617E),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Məhəmməd Qardaşov',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;

  const _HeaderButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Icon(icon, color: const Color(0xFF9EB0C8), size: 22),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, color: Color(0xFF9CA9BA), size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Poliklinik, həkim, xəstəxana axtar...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFB1BCCB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NÖVBƏ AL',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
              color: Color(0xFF9AA5B8),
            ),
          ),
          const SizedBox(height: 13),
          _ServiceCard(
            icon: Icons.group_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: 'Ailə Həkimindən',
            subtitle: 'Qeydiyyatda olduğunuz həkim',
            onTap: () => _go(context),
          ),
          const SizedBox(height: 11),
          _ServiceCard(
            icon: Icons.local_hospital_outlined,
            iconColor: const Color(0xFFD94B3D),
            iconBg: const Color(0xFFFFECEA),
            title: 'Xəstəxanadan',
            subtitle: 'Dövlət və özəl müəssisələr',
            onTap: () => _go(context),
          ),
          const SizedBox(height: 11),
          _ServiceCard(
            icon: Icons.monitor_heart_outlined,
            iconColor: const Color(0xFF159B55),
            iconBg: const Color(0xFFE7F8EF),
            title: 'Sağlam Həyat Mərkəzi',
            subtitle: 'Profilaktika xidmətləri',
            onTap: () => _go(context),
          ),
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

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(16, 14, 15, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE9EDF3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 14),
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
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8D99AB),
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFFC4CEDA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  final VoidCallback onViewAll;

  const _UpcomingSection({required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Yaxınlaşan növbələrim',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF9AA5B8),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Text(
                  'Hamısı',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFD9E1EC),
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  color: Color(0xFFD2DBE7),
                  size: 34,
                ),
                SizedBox(height: 8),
                Text(
                  'Aktiv növbəniz yoxdur',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB1BCCB),
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
