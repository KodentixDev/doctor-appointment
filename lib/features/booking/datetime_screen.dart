import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../appointments/data/appointments_api.dart';
import 'confirmation_screen.dart';

class DateTimeScreen extends StatefulWidget {
  final int doctorId;
  final String doctorName;
  final String specialty;

  const DateTimeScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
  });

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  final _api = AppointmentsApi();

  static const _monthNames = [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'İyun',
    'İyul',
    'Avqust',
    'Sentyabr',
    'Oktyabr',
    'Noyabr',
    'Dekabr',
  ];
  static const _dayLabels = ['B.E', 'Ç.A', 'Ç', 'C.A', 'C', 'Ş', 'B'];

  List<String> _availableDates = [];
  String? _selectedDate;
  List<Map<String, String>> _slots = [];
  Map<String, String>? _selectedSlot;

  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  bool _loadingDays = true;
  bool _loadingSlots = false;
  bool _booking = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAvailableDays();
  }

  Future<void> _loadAvailableDays() async {
    setState(() {
      _loadingDays = true;
      _error = null;
    });
    try {
      final dates = await _api.availableDays(widget.doctorId);
      if (!mounted) return;
      setState(() {
        _availableDates = dates;
        _loadingDays = false;
      });
      if (dates.isNotEmpty) {
        final first = dates.first;
        final parts = first.split('-');
        if (parts.length == 3) {
          _month = int.parse(parts[1]);
          _year = int.parse(parts[0]);
        }
        _selectDate(first);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loadingDays = false;
        });
      }
    }
  }

  Future<void> _selectDate(String date) async {
    setState(() {
      _selectedDate = date;
      _loadingSlots = true;
      _slots = [];
      _selectedSlot = null;
    });
    try {
      final slots = await _api.availableSlots(widget.doctorId, date);
      if (mounted) {
        setState(() {
          _slots = slots;
          _loadingSlots = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingSlots = false;
        });
      }
    }
  }

  Future<void> _book() async {
    if (_selectedDate == null || _selectedSlot == null) return;
    setState(() => _booking = true);
    try {
      final appointment = await _api.bookAppointment(
        doctorId: widget.doctorId,
        appointmentDate: _selectedDate!,
        startTime: _selectedSlot!['start']!,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(appointment: appointment),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (_selectedDate != null) {
        await _selectDate(_selectedDate!);
      }
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  void _prevMonth() => setState(() {
    if (_month == 1) {
      _month = 12;
      _year--;
    } else {
      _month--;
    }
  });

  void _nextMonth() => setState(() {
    if (_month == 12) {
      _month = 1;
      _year++;
    } else {
      _month++;
    }
  });

  List<DateTime> get _daysInMonth {
    final lastDay = DateTime(_year, _month + 1, 0).day;
    return List.generate(lastDay, (i) => DateTime(_year, _month, i + 1));
  }

  bool _isAvailable(DateTime date) {
    final s = _toIso(date);
    return _availableDates.contains(s);
  }

  bool _isSelected(DateTime date) => _toIso(date) == _selectedDate;

  String _toIso(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String get _doctorInitials {
    final name = widget.doctorName.replaceFirst('Dr. ', '').trim();
    final parts = name.split(' ');
    final f = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final l = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$f$l'.toUpperCase();
  }

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
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loadingDays) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFCBD8E5)),
            const SizedBox(height: 12),
            Text(
              context.tr('Boş günlər yüklənmədi'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7D93AB),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadAvailableDays,
              child: Text(context.tr('Yenidən cəhd et')),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        _buildDayStrip(),
        const SizedBox(height: 8),
        if (_loadingSlots)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_selectedDate != null && _slots.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                context.tr('Bu tarixdə boş slot yoxdur'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7D93AB),
                ),
              ),
            ),
          )
        else if (_slots.isNotEmpty) ...[
          _sectionLabel(context, 'MÖVCUD VAXTLAR'),
          _buildSlotGrid(context),
        ],
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _selectedSlot != null && !_booking
                  ? const LinearGradient(
                      colors: [Color(0xFF1B4FD8), Color(0xFF2563EB)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFCBD8E5), Color(0xFFCBD8E5)],
                    ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedSlot != null && !_booking ? _book : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  disabledBackgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _booking
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
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
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final translatedMonth = context.tr(_monthNames[_month - 1]);
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
                child: Text(
                  _doctorInitials,
                  style: const TextStyle(
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
                  Text(
                    '${widget.doctorName} · ${widget.specialty}',
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
            current: 4,
            labels: [
              context.tr('Şəhər'),
              context.tr('Xəstəxana'),
              context.tr('Bölüm'),
              context.tr('Həkim'),
              context.tr('Tarix'),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$translatedMonth $_year',
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

  Widget _buildDayStrip() {
    final days = _daysInMonth;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final date = days[i];
          final avail = _isAvailable(date);
          final sel = _isSelected(date);
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
            onTap: avail ? () => _selectDate(_toIso(date)) : null,
            child: Container(
              width: 42,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr(_dayLabels[date.weekday - 1]),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: lblC,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
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
        },
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

  Widget _buildSlotGrid(BuildContext context) {
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
        itemCount: _slots.length,
        itemBuilder: (_, i) {
          final slot = _slots[i];
          final sel =
              _selectedSlot == slot ||
              (_selectedSlot?['start'] == slot['start'] &&
                  _selectedSlot?['end'] == slot['end']);
          final Color bg = sel
              ? const Color(0xFF1B4FD8)
              : const Color(0xFFEFF6FF);
          final Color fg = sel ? Colors.white : const Color(0xFF1B4FD8);
          final Color bd = sel
              ? const Color(0xFF1B4FD8)
              : const Color(0xFFBFD7F8);
          return GestureDetector(
            onTap: () => setState(() => _selectedSlot = slot),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bd, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                slot['start'] ?? '',
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
