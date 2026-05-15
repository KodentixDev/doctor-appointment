import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
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
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: Text(
                      context.tr('XƏSTƏXANALAR'),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: Color(0xFF7D93AB),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: List.generate(_hospitals.length, (index) {
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
                    context.tr('Xəstəxana Seçin'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B1829),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    context.tr('Bakı · Addım 2'),
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
            current: 1,
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
                  context.tr('Xəstəxana axtar...'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0F5FF) : Colors.white,
          border: Border(
            bottom: const BorderSide(color: Color(0xFFE8EFF8), width: 0.5),
            left: selected
                ? const BorderSide(color: Color(0xFF1B4FD8), width: 3)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFBFD7F8)
                    : const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_hospital_outlined,
                color: selected
                    ? const Color(0xFF1B4FD8)
                    : const Color(0xFF7D93AB),
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
                          ? const Color(0xFF1B4FD8)
                          : const Color(0xFF0B1829),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7D93AB),
                    ),
                  ),
                ],
              ),
            ),
            if (hasSlot) ...[
              HnBadge(
                label: context.tr('Boş var'),
                bg: AppColors.successLight,
                fg: AppColors.success,
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right,
              color: selected
                  ? const Color(0xFF1B4FD8)
                  : const Color(0xFFCBD8E5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
