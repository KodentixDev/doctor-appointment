import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/hn_bottom_nav.dart';
import '../appointments/appointments_screen.dart';
import '../menu/menu_screen.dart';
import '../search/search_screen.dart';
import '../booking/city_screen.dart';

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
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: IndexedStack(
          index: _idx,
          children: const [
            _HomeBody(),
            AppointmentsScreen(),
            AppointmentsScreen(),
            MenuScreen(),
          ],
        ),
        bottomNavigationBar: HnBottomNav(
          currentIndex: _idx,
          onTap: (i) => setState(() => _idx = i),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header()),
        SliverToBoxAdapter(child: _SearchBar()),
        SliverToBoxAdapter(child: _ServicesSection()),
        SliverToBoxAdapter(child: _UpcomingSection()),
        const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.bgDark,
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 56),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.navBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.bgDarkBorder),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: AppColors.primaryMid,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        children: [
                          TextSpan(
                            text: 'Həkim',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Növbə',
                            style: TextStyle(color: AppColors.primaryMid),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Xoş gəldiniz',
                  style: TextStyle(fontSize: 12, color: Color(0xFF3A5070)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mahammad Gardaşov',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _HdrBtn(icon: Icons.notifications_outlined),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'MG',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HdrBtn extends StatelessWidget {
  final IconData icon;
  const _HdrBtn({required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
    ),
    child: Icon(icon, color: Colors.white.withValues(alpha: 0.55), size: 18),
  );
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderMid),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: AppColors.textMuted, size: 19),
                SizedBox(width: 10),
                Text(
                  'Poliklinik, həkim, xəstəxana axtar...',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NÖVBƏ AL', style: AppTextStyles.overline),
          const SizedBox(height: 12),
          _SvcCard(
            icon: Icons.person_outline,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: 'Ailə Həkimindən',
            subtitle: 'Qeydiyyatda olduğunuz həkim',
            onTap: () => _go(context),
          ),
          const SizedBox(height: 8),
          _SvcCard(
            icon: Icons.local_hospital_outlined,
            iconColor: AppColors.danger,
            iconBg: AppColors.dangerLight,
            title: 'Xəstəxanadan',
            subtitle: 'Dövlət və özəl müəssisələr',
            onTap: () => _go(context),
          ),
          const SizedBox(height: 8),
          _SvcCard(
            icon: Icons.favorite_border,
            iconColor: AppColors.success,
            iconBg: AppColors.successLight,
            title: 'Sağlam Həyat Mərkəzi',
            subtitle: 'Profilaktika xidmətləri',
            onTap: () => _go(context),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const CityScreen()),
  );
}

class _SvcCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final VoidCallback onTap;
  const _SvcCard({
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.sub),
                ],
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'YAXINLAŞAN NÖVBƏLƏRIM',
                style: AppTextStyles.overline,
              ),
              Text(
                'Hamısı',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              style: BorderStyle.solid,
            ),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.textDimmed,
                size: 26,
              ),
              SizedBox(height: 10),
              Text(
                'Aktiv növbəniz yoxdur',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
