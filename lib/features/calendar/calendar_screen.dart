import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedMonth = DateTime(2026, 5);
  DateTime? _selectedDay;

  static const _appointments = {
    8: _ApptInfo('Dr. Nigar Abbasova', '09:30', Color(0xFF1A5AD7)),
    15: _ApptInfo('Dr. Leyla Həsənova', '14:00', Color(0xFF0D7A5F)),
  };

  static const _weekDays = ['B.e', 'Ç.a', 'Ç', 'C.a', 'C', 'Ş', 'B'];

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    int startOffset = firstDay.weekday - 1;
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final total = startOffset + daysInMonth;
    final cells = (total / 7).ceil() * 7;
    return List.generate(cells, (i) {
      final day = i - startOffset + 1;
      if (day < 1 || day > daysInMonth) return null;
      return DateTime(_focusedMonth.year, _focusedMonth.month, day);
    });
  }

  void _prevMonth() => setState(
        () => _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month - 1),
      );

  void _nextMonth() => setState(
        () => _focusedMonth =
            DateTime(_focusedMonth.year, _focusedMonth.month + 1),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F3F7),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _buildCalendar(),
                    const SizedBox(height: 12),
                    _buildScheduleSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final monthNames = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'İyun',
      'İyul', 'Avqust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr',
    ];
    return Container(
      color: const Color(0xFF071427),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 18,
        20,
        18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Təqvim',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFA726),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF162336),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF162336),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final days = _buildCalendarDays();
    final today = DateTime.now();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: _weekDays
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8B98AA),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) {
              final date = days[i];
              if (date == null) return const SizedBox();
              final day = date.day;
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isSelected = _selectedDay != null &&
                  date.year == _selectedDay!.year &&
                  date.month == _selectedDay!.month &&
                  date.day == _selectedDay!.day;
              final hasAppt = _appointments.containsKey(day) &&
                  date.month == _focusedMonth.month;

              return GestureDetector(
                onTap: () => setState(() => _selectedDay = date),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A5AD7)
                            : isToday
                                ? const Color(0xFFEAF1FF)
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? const Color(0xFF1A5AD7)
                                  : const Color(0xFF06152B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: hasAppt
                            ? (isSelected
                                ? Colors.white
                                : const Color(0xFF1A5AD7))
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    final hasAppts = _appointments.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 0, 10),
            child: Text(
              'PLANLAŞDIRILMIŞ NÖVBƏLƏR',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: Color(0xFF8B98AA),
              ),
            ),
          ),
          if (!hasAppts)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 36,
                    color: Color(0xFFD2DBE7),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Planlaşdırılmış növbə yoxdur',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB1BCCB),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._appointments.entries.map((e) {
              final date = DateTime(
                  _focusedMonth.year, _focusedMonth.month, e.key);
              return _ScheduleCard(date: date, info: e.value);
            }),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final DateTime date;
  final _ApptInfo info;

  const _ScheduleCard({required this.date, required this.info});

  static const _monthShort = [
    'Yan', 'Fev', 'Mar', 'Apr', 'May', 'İyn',
    'İyl', 'Avq', 'Sen', 'Okt', 'Noy', 'Dek',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A5AD7),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _monthShort[date.month - 1],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A5AD7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.doctorName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF06152B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 13,
                      color: Color(0xFF8B98AA),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      info.time,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B98AA),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: info.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApptInfo {
  final String doctorName;
  final String time;
  final Color color;

  const _ApptInfo(this.doctorName, this.time, this.color);
}
