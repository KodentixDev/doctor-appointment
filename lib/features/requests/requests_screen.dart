import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  static const _requests = [
    _RequestItem(
      title: 'Laborator analiz nəticəsi',
      subtitle: 'Bakı Şəhər Klinik Xəstəxanası',
      status: 'Gözləmədə',
      statusColor: Color(0xFFB46B05),
      statusBg: Color(0xFFFFF1D9),
      icon: Icons.science_outlined,
      iconColor: Color(0xFF1746A2),
      iconBg: Color(0xFFEBF2FF),
      date: '7 May 2026',
    ),
    _RequestItem(
      title: 'Elektron göndəriş',
      subtitle: 'Kardiologiya şöbəsi',
      status: 'Təsdiqləndi',
      statusColor: Color(0xFF137A33),
      statusBg: Color(0xFFDDF9E7),
      icon: Icons.description_outlined,
      iconColor: Color(0xFF137A33),
      iconBg: Color(0xFFE8F8EE),
      date: '6 May 2026',
    ),
    _RequestItem(
      title: 'Sığorta müraciəti',
      subtitle: 'İcbari Tibbi Sığorta',
      status: 'Baxılır',
      statusColor: Color(0xFF1746A2),
      statusBg: Color(0xFFEBF2FF),
      icon: Icons.verified_user_outlined,
      iconColor: Color(0xFF1746A2),
      iconBg: Color(0xFFEBF2FF),
      date: '5 May 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSummary()),
            SliverToBoxAdapter(child: _sectionTitle()),
            SliverList.builder(
              itemCount: _requests.length,
              itemBuilder: (context, index) => _RequestCard(
                item: _requests[index],
                onTap: () {},
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 22)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 24,
        16,
        18,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tələblər',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF06152B),
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Müraciət və sorğularınızı izləyin',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B98AA),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.add_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Row(
        children: const [
          Expanded(
            child: _SummaryTile(
              value: '3',
              label: 'Aktiv tələb',
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _SummaryTile(
              value: '1',
              label: 'Gözləmədə',
              color: AppColors.amber,
              bg: AppColors.amberLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Text(
        'SON TƏLƏBLƏR',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.1,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bg;

  const _SummaryTile({
    required this.value,
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final _RequestItem item;
  final VoidCallback onTap;

  const _RequestCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
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
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        item.date,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSub,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: item.statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: AppColors.textDimmed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestItem {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String date;

  const _RequestItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.date,
  });
}
