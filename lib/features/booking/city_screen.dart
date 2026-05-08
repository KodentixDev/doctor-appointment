import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../../core/widgets/hn_badge.dart';
import 'hospital_screen.dart';

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
                      context.tr('ŞƏHƏRLƏR'),
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
                      children: List.generate(
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
                                builder: (_) => const HospitalScreen(),
                              ),
                            );
                          },
                        ),
                      ),
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
                    context.tr('Növbə Al'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B1829),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    context.tr('Addım 1 — Şəhər seçin'),
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
            current: 0,
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
                  context.tr('Şəhər axtar...'),
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
                Icons.location_on_outlined,
                color: selected
                    ? const Color(0xFF1B4FD8)
                    : const Color(0xFF7D93AB),
                size: 24,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? const Color(0xFF1B4FD8)
                          : const Color(0xFF0B1829),
                    ),
                  ),
                  if (subtitle.isNotEmpty)
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
            if (selected) ...[
              HnBadge(
                label: context.tr('Seçildi'),
                bg: const Color(0xFFEFF6FF),
                fg: const Color(0xFF1B4FD8),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              selected ? Icons.check_rounded : Icons.chevron_right,
              color: selected
                  ? const Color(0xFF1B4FD8)
                  : const Color(0xFFCBD8E5),
              size: selected ? 22 : 24,
            ),
          ],
        ),
      ),
    );
  }
}
