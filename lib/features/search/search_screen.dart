import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/localization/app_language.dart';
import '../booking/city_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _filter = 0;

  // Keys for the filter labels (translated at build time)
  static const _filterKeys = ['Həkimlər', 'Klinikalar', 'Xəstəxanalar'];

  static const _doctors = [
    {
      'initials': 'NA',
      'name': 'Dr. Nigar Abbasova',
      'spec': 'Kardioloq · Şəhər Klinik Xəstəxanası',
      'slot': '9 May, 10:00',
      'rating': '4.8',
      'color': 0xFF1746A2,
    },
    {
      'initials': 'RM',
      'name': 'Dr. Rauf Məmmədov',
      'spec': 'Kardioloq · RKX',
      'slot': '10 May, 09:30',
      'rating': '4.6',
      'color': 0xFF0F766E,
    },
    {
      'initials': 'LH',
      'name': 'Dr. Leyla Həsənova',
      'spec': 'Kardioloq · Klinik Xəstəxana №3',
      'slot': '12 May, 14:00',
      'rating': '4.9',
      'color': 0xFF7C3AED,
    },
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
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 20),
                itemCount: _doctors.length,
                itemBuilder: (_, i) => _DoctorCard(
                  doc: _doctors[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CityScreen()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final filters = _filterKeys.map((k) => context.tr(k)).toList();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16,
        right: 16,
        bottom: 14,
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
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgSubtle,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Kardioloq',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(filters.length, (i) {
                final on = i == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: on ? AppColors.primaryLight : Colors.white,
                      border: Border.all(
                        color: on
                            ? AppColors.primaryBorder
                            : AppColors.borderMid,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      filters[i],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: on ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doc;
  final VoidCallback onTap;
  const _DoctorCard({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                backgroundColor: Color(doc['color'] as int),
                child: Text(
                  doc['initials'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                        Text(
                          doc['name'] as String,
                          style: AppTextStyles.cardTitle,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF59E0B),
                              size: 17,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              doc['rating'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(doc['spec'] as String, style: AppTextStyles.sub),
                    const SizedBox(height: 6),
                    Text(
                      '${context.tr('İlk boş vaxt:')} ${doc['slot']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                context.tr('Növbə Al'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
