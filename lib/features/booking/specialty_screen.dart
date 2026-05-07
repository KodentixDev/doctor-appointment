import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../../core/widgets/hn_badge.dart';
import 'datetime_screen.dart';

class SpecialtyScreen extends StatelessWidget {
  const SpecialtyScreen({super.key});

  static const _specs = [
    (Icons.favorite_border,        'Kardioloq',    '14 həkim',  true),
    (Icons.psychology_outlined,    'Nevroloq',     '8 həkim',   false),
    (Icons.accessibility_outlined, 'Ortoped',      '5 həkim',   false),
    (Icons.remove_red_eye_outlined,'Oftalmoloq',   '6 həkim',   false),
    (Icons.air_outlined,           'Pulmonoloq',   '4 həkim',   false),
    (Icons.biotech_outlined,       'Endokrinoloq', '3 həkim',   false),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(children: [
          _buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _specs.length,
              separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.bgPage),
              itemBuilder: (ctx, i) {
                final s = _specs[i];
                return GestureDetector(
                  onTap: () => Navigator.push(ctx,
                    MaterialPageRoute(builder: (_) => const DateTimeScreen())),
                  child: Container(
                    color: s.$4 ? AppColors.primaryLight : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: s.$4 ? AppColors.primaryBorder : AppColors.bgSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(s.$1,
                          color: s.$4 ? AppColors.primary : AppColors.textMuted, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$2, style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: -0.1,
                            color: s.$4 ? AppColors.primary : AppColors.textPrimary,
                          )),
                          const SizedBox(height: 2),
                          Text(s.$3, style: AppTextStyles.sub),
                        ],
                      )),
                      if (s.$4)
                        HnBadge(label: 'Boş var',
                          bg: AppColors.successLight, fg: AppColors.success),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right,
                        color: s.$4 ? AppColors.primary : AppColors.textDimmed, size: 20),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16, right: 16, bottom: 0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.bgSubtle, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new, size: 15, color: AppColors.textSub),
            ),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Bölüm Seçin',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary, letterSpacing: -0.3)),
            Text('Bakı · Şəhər Klinik Xəstəxanası', style: AppTextStyles.sub),
          ]),
        ]),
        StepProgressBar(current: 2, labels: const ['Şəhər','Xəstəxana','Bölüm','Həkim','Tarix']),
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.bgSubtle, borderRadius: BorderRadius.circular(10)),
          child: Row(children: const [
            Icon(Icons.search, color: AppColors.textMuted, size: 16),
            SizedBox(width: 10),
            Text('Bölüm axtar...', style: AppTextStyles.sub),
          ]),
        ),
      ]),
    );
  }
}