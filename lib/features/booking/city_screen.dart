import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../../core/widgets/hn_badge.dart';
import 'specialty_screen.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  int _sel = 0;
  static const _cities = [
    ('Bakı', 'Paytaxt · 47 xəstəxana'),
    ('Gəncə', 'II ən böyük şəhər'),
    ('Sumqayıt', 'Sənaye şəhəri'),
    ('Lənkəran', ''),
    ('Mingəçevir', ''),
    ('Naxçıvan', ''),
    ('Şəki', ''),
  ];

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
            _buildHeader(context),
            Expanded(
              child: ListView(
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
                            'ŞƏHƏRlƏR',
                            style: AppTextStyles.overline,
                          ),
                        ),
                        ...List.generate(
                          _cities.length,
                          (i) => _CityItem(
                            name: _cities[i].$1,
                            subtitle: _cities[i].$2,
                            selected: i == _sel,
                            onTap: () {
                              setState(() => _sel = i);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SpecialtyScreen(),
                                ),
                              );
                            },
                          ),
                        ),
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bgSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                    color: AppColors.textSub,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Növbə Al',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text('Addım 1 — Şəhər seçin', style: AppTextStyles.sub),
                ],
              ),
            ],
          ),
          StepProgressBar(
            current: 0,
            labels: const ['Şəhər', 'Xəstəxana', 'Bölüm', 'Həkim', 'Tarix'],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: AppColors.textMuted, size: 16),
                SizedBox(width: 10),
                Text('Şəhər axtar...', style: AppTextStyles.sub),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityItem extends StatelessWidget {
  final String name, subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _CityItem({
    required this.name,
    required this.subtitle,
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryBorder : AppColors.bgSubtle,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: selected ? AppColors.primary : AppColors.textMuted,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.1,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: AppTextStyles.sub),
                ],
              ),
            ),
            if (selected) ...[
              HnBadge(
                label: 'Seçildi',
                bg: AppColors.primaryLight,
                fg: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ] else
              const Icon(
                Icons.chevron_right,
                color: AppColors.textDimmed,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
