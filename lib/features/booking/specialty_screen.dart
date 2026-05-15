import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../../core/widgets/hn_badge.dart';
import 'doctor_screen.dart';

class SpecialtyScreen extends StatelessWidget {
  const SpecialtyScreen({super.key});

  // (icon, specialty label, doctor count, hasAvailability)
  static const _specs = [
    (Icons.favorite_border, 'Kardioloq', '14 həkim', true),
    (Icons.psychology_outlined, 'Nevroloq', '8 həkim', true),
    (Icons.accessibility_outlined, 'Ortoped', '5 həkim', true),
    (Icons.remove_red_eye_outlined, 'Oftalmoloq', '6 həkim', true),
    (Icons.air_outlined, 'Pulmonoloq', '4 həkim', true),
    (Icons.biotech_outlined, 'Endokrinoloq', '3 həkim', true),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _specs.length,
                  separatorBuilder: (_, _) => Container(
                    margin: const EdgeInsets.only(left: 68),
                    height: 0.5,
                    color: const Color(0xFFE8EFF8),
                  ),
                  itemBuilder: (ctx, i) {
                    final s = _specs[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => DoctorScreen(specialty: s.$2),
                        ),
                      ),
                      child: Container(
                        color: s.$4 ? const Color(0xFFF0F5FF) : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: s.$4
                                    ? const Color(0xFFBFD7F8)
                                    : const Color(0xFFF5F8FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                s.$1,
                                color: s.$4
                                    ? const Color(0xFF1B4FD8)
                                    : const Color(0xFF7D93AB),
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr(s.$2),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.1,
                                      color: s.$4
                                          ? const Color(0xFF1B4FD8)
                                          : const Color(0xFF0B1829),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.tr(s.$3),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF7D93AB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (s.$4) ...[
                              HnBadge(
                                label: context.tr('Boş var'),
                                bg: AppColors.successLight,
                                fg: AppColors.success,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Icon(
                              Icons.chevron_right,
                              color: s.$4
                                  ? const Color(0xFF1B4FD8)
                                  : const Color(0xFFCBD8E5),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF1B4FD8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Bölüm Seçin'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B1829),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    context.tr('Bakı · Şəhər Klinik Xəstəxanası'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D93AB),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StepProgressBar(
            current: 2,
            labels: [
              context.tr('Şəhər'),
              context.tr('Xəstəxana'),
              context.tr('Bölüm'),
              context.tr('Həkim'),
              context.tr('Tarix'),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              border: Border.all(color: const Color(0xFFD8E4F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF7D93AB), size: 20),
                const SizedBox(width: 10),
                Text(
                  context.tr('Bölüm axtar...'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7D93AB),
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
