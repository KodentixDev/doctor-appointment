import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../booking/city_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _filter = 0;

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
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 19,
                    color: Color(0xFF2C4159),
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
                    color: const Color(0xFFF5F8FF),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
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
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: on
                          ? const Color(0xFFEFF6FF)
                          : Colors.white,
                      border: Border.all(
                        color: on
                            ? const Color(0xFFBFD7F8)
                            : const Color(0xFFD8E4F0),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      filters[i],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: on ? FontWeight.w700 : FontWeight.w600,
                        color: on
                            ? AppColors.primary
                            : AppColors.textMuted,
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
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0B1829),
                            ),
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
                      Text(
                        doc['spec'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7D93AB),
                        ),
                      ),
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
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
            ),
          ),
        ],
      ),
    );
  }
}
