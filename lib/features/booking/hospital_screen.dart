import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/hn_badge.dart';
import '../../core/widgets/step_progress_bar.dart';
import 'specialty_screen.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  int _selected = 0;

  static const _hospitals = [
    ('Bakı Şəhər Klinik Xəstəxanası', 'Kardiologiya · 14 həkim', true),
    ('Respublika Klinik Xəstəxanası', 'Ümumi tibbi xidmətlər', true),
    ('Mərkəzi Neftçilər Xəstəxanası', 'Diaqnostika və müalicə', false),
    ('Klinik Tibbi Mərkəz', 'Dövlət xəstəxanası', false),
    ('MedEra Hospital', 'Özəl tibb mərkəzi', true),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: AppColors.bgPage),
                            ),
                          ),
                          child: const Text(
                            'XƏSTƏXANALAR',
                            style: AppTextStyles.overline,
                          ),
                        ),
                        ...List.generate(_hospitals.length, (index) {
                          final hospital = _hospitals[index];
                          return _HospitalItem(
                            name: hospital.$1,
                            subtitle: hospital.$2,
                            hasSlot: hospital.$3,
                            selected: index == _selected,
                            onTap: () {
                              setState(() => _selected = index);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SpecialtyScreen(),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bgSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 19,
                    color: AppColors.textSub,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xəstəxana Seçin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text('Bakı · Addım 2', style: AppTextStyles.sub),
                ],
              ),
            ],
          ),
          const StepProgressBar(
            current: 1,
            labels: ['Şəhər', 'Xəstəxana', 'Bölüm', 'Həkim', 'Tarix'],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: AppColors.textMuted, size: 20),
                SizedBox(width: 10),
                Text('Xəstəxana axtar...', style: AppTextStyles.sub),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool hasSlot;
  final bool selected;
  final VoidCallback onTap;

  const _HospitalItem({
    required this.name,
    required this.subtitle,
    required this.hasSlot,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          border: const Border(bottom: BorderSide(color: AppColors.bgPage)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryBorder : AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_hospital_outlined,
                color: selected ? AppColors.primary : AppColors.textMuted,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.sub),
                ],
              ),
            ),
            if (hasSlot) ...[
              HnBadge(
                label: 'Boş var',
                bg: AppColors.successLight,
                fg: AppColors.success,
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right,
              color: selected ? AppColors.primary : AppColors.textDimmed,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
