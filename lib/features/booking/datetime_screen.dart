import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import 'confirmation_screen.dart';

enum SlotStatus { available, selected, full }

class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});
  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  int _dayIdx = 3;
  int _month = 5;
  int _year = 2026;

  static const _monthNames = [
    'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'İyun',
    'İyul', 'Avqust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr',
  ];

  void _prevMonth() => setState(() {
    if (_month == 1) { _month = 12; _year--; } else { _month--; }
  });

  void _nextMonth() => setState(() {
    if (_month == 12) { _month = 1; _year++; } else { _month++; }
  });

  static const _days = [
    ('B.E', '5', false),
    ('Ç.A', '6', false),
    ('Ç',   '7', false),
    ('C.A', '8', true),
    ('C',   '9', true),
    ('Ş',  '10', false),
    ('B',  '11', true),
  ];

  final _morningTimes = ['08:00', '08:30', '09:00', '09:30', '10:00', '10:30'];
  late final _morningStatus = [
    SlotStatus.full,
    SlotStatus.full,
    SlotStatus.available,
    SlotStatus.selected,
    SlotStatus.available,
    SlotStatus.available,
  ];

  final _afternoonTimes = ['12:00', '12:30', '13:00'];
  final _afternoonStatus = [
    SlotStatus.full,
    SlotStatus.available,
    SlotStatus.available,
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
                  _buildCalStrip(),
                  const SizedBox(height: 8),
                  _sectionLabel(context, 'SƏHƏR'),
                  _buildSlotGrid(_morningTimes, _morningStatus, (i) {
                    setState(() {
                      for (var j = 0; j < _morningStatus.length; j++) {
                        if (_morningStatus[j] == SlotStatus.selected) {
                          _morningStatus[j] = SlotStatus.available;
                        }
                      }
                      _morningStatus[i] = SlotStatus.selected;
                    });
                  }),
                  _sectionLabel(context, 'GÜNORTA'),
                  _buildSlotGrid(_afternoonTimes, _afternoonStatus, (_) {}),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfirmationScreen(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            context.tr('Növbəni Təsdiqlə'),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final translatedMonthNames = _monthNames
        .map((m) => context.tr(m))
        .toList();

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
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xFF2C4159),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 16,
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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('Tarix Seçin'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B1829),
                    ),
                  ),
                  const Text(
                    'Dr. Nigar Abbasova · Kardioloq',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D93AB),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${translatedMonthNames[_month - 1]} $_year',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B4FD8),
                  letterSpacing: -0.2,
                ),
              ),
              Row(
                children: [
                  _navBtn(Icons.chevron_left, _prevMonth),
                  const SizedBox(width: 4),
                  _navBtn(Icons.chevron_right, _nextMonth),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 22, color: const Color(0xFF7D93AB)),
    ),
  );

  Widget _buildCalStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (i) {
          final d = _days[i];
          final avail = d.$3;
          final sel = i == _dayIdx;
          final Color bg = sel
              ? const Color(0xFF1B4FD8)
              : avail
              ? const Color(0xFFEFF6FF)
              : Colors.transparent;
          final Color numC = sel
              ? Colors.white
              : avail
              ? const Color(0xFF1B4FD8)
              : const Color(0xFFCBD8E5);
          final Color lblC = sel
              ? Colors.white.withValues(alpha: 0.7)
              : avail
              ? const Color(0xFF4C7ADB)
              : const Color(0xFFCBD8E5);
          return GestureDetector(
            onTap: avail ? () => setState(() => _dayIdx = i) : null,
            child: Container(
              width: 42,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    d.$1,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: lblC,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    d.$2,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: numC,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String key) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
    child: Text(
      context.tr(key),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
        color: Color(0xFF7D93AB),
      ),
    ),
  );

  Widget _buildSlotGrid(
    List<String> times,
    List<SlotStatus> statuses,
    ValueChanged<int> onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.4,
        ),
        itemCount: times.length,
        itemBuilder: (_, i) {
          final st = statuses[i];
          Color bg, fg, bd;
          switch (st) {
            case SlotStatus.selected:
              bg = const Color(0xFF1B4FD8);
              fg = Colors.white;
              bd = const Color(0xFF1B4FD8);
            case SlotStatus.available:
              bg = const Color(0xFFEFF6FF);
              fg = const Color(0xFF1B4FD8);
              bd = const Color(0xFFBFD7F8);
            case SlotStatus.full:
              bg = const Color(0xFFF5F8FF);
              fg = const Color(0xFFCBD8E5);
              bd = const Color(0xFFE8EFF8);
          }
          return GestureDetector(
            onTap: st != SlotStatus.full ? () => onTap(i) : null,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bd, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                times[i],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
