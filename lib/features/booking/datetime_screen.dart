import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
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
    ('Ç', '7', false),
    ('C.A', '8', true),
    ('C', '9', true),
    ('Ş', '10', false),
    ('B', '11', true),
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
                  _sectionLabel('SƏHƏR'),
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
                  _sectionLabel('GÜNORTA'),
                  _buildSlotGrid(_afternoonTimes, _afternoonStatus, (_) {}),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConfirmationScreen(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Növbəni Təsdiqlə',
                        style: AppTextStyles.btnLabel,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                children: const [
                  Text(
                    'Tarix Seçin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Dr. Nigar Abbasova · Kardioloq',
                    style: AppTextStyles.sub,
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
                '${_monthNames[_month - 1]} $_year',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
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
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.bgSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 22, color: AppColors.textMuted),
    ),
  );

  Widget _buildCalStrip() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (i) {
          final d = _days[i];
          final avail = d.$3;
          final sel = i == _dayIdx;
          Color bg = sel
              ? AppColors.primary
              : avail
              ? AppColors.primaryLight
              : Colors.transparent;
          Color numC = sel
              ? Colors.white
              : avail
              ? AppColors.primary
              : AppColors.textDimmed;
          Color lblC = sel
              ? Colors.white.withValues(alpha: 0.6)
              : avail
              ? const Color(0xFF4C7ADB)
              : AppColors.textDimmed;
          return GestureDetector(
            onTap: avail ? () => setState(() => _dayIdx = i) : null,
            child: Container(
              width: 38,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                children: [
                  Text(
                    d.$1,
                    style: TextStyle(
                      fontSize: 11,
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

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
    child: Text(text, style: AppTextStyles.overline),
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
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
          childAspectRatio: 2.5,
        ),
        itemCount: times.length,
        itemBuilder: (_, i) {
          final st = statuses[i];
          Color bg, fg, bd;
          switch (st) {
            case SlotStatus.selected:
              bg = AppColors.primary;
              fg = Colors.white;
              bd = AppColors.primary;
            case SlotStatus.available:
              bg = AppColors.primaryLight;
              fg = AppColors.primary;
              bd = AppColors.primaryBorder;
            case SlotStatus.full:
              bg = AppColors.bgSubtle;
              fg = AppColors.textDimmed;
              bd = AppColors.border;
          }
          return GestureDetector(
            onTap: st != SlotStatus.full ? () => onTap(i) : null,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bd, width: 1.5),
                borderRadius: BorderRadius.circular(10),
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
