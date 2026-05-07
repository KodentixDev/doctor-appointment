import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/hn_badge.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Növbələrim', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 14),
                  TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Növbələrim'),
                      Tab(text: 'Keçmiş'),
                      Tab(text: 'Gizli'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _buildActive(),
                  _empty('Keçmiş növbəniz yoxdur'),
                  _empty('Gizli növbəniz yoxdur'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActive() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'NA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dr. Nigar Abbasova',
                              style: AppTextStyles.cardTitle,
                            ),
                            HnBadge(
                              label: 'Təsdiqləndi',
                              bg: AppColors.successLight,
                              fg: AppColors.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Kardioloq · Şəhər Klinik Xəstəxanası',
                          style: AppTextStyles.sub,
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(width: 6),
                            Text('8 May 2026', style: AppTextStyles.sub),
                            SizedBox(width: 16),
                            Icon(
                              Icons.access_time_outlined,
                              size: 13,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(width: 6),
                            Text('09:30', style: AppTextStyles.sub),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      'Detallar',
                      AppColors.bgSubtle,
                      AppColors.textPrimary,
                      () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _actionBtn(
                      'Ləğv Et',
                      AppColors.dangerLight,
                      AppColors.danger,
                      () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionBtn(String label, Color bg, Color fg, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ),
      );

  Widget _empty(String msg) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.calendar_month_outlined,
          size: 32,
          color: AppColors.textDimmed,
        ),
        const SizedBox(height: 10),
        Text(
          msg,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
