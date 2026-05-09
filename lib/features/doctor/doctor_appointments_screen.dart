import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  int _tab = 0;

  static const _appointments = [
    _DoctorAppointmentData(
      initials: 'MG',
      patientName: 'M\u{0259}h\u{0259}mm\u{0259}d Qarda\u{015F}ov',
      fin: 'FIN: 5MK2839',
      status: 'T\u{0259}sdiql\u{0259}ndi',
      statusColor: AppColors.success,
      statusBg: AppColors.successLight,
      reason: 'D\u{00F6}\u{015F} nahiy\u{0259}sind\u{0259} a\u{011F}r\u{0131}',
      date: 'Bug\u{00FC}n',
      time: '09:30',
      room: 'Kabin\u{0259} 204',
      code: 'AZ-004821',
    ),
    _DoctorAppointmentData(
      initials: 'SA',
      patientName: 'S\u{0259}bin\u{0259} Al\u{0131}yeva',
      fin: 'FIN: 7RK1934',
      status: 'G\u{00F6}zl\u{0259}nilir',
      statusColor: AppColors.amber,
      statusBg: AppColors.amberLight,
      reason: 'Planl\u{0131} konsultasiya',
      date: 'Bug\u{00FC}n',
      time: '11:00',
      room: 'Kabin\u{0259} 204',
      code: 'AZ-004839',
    ),
    _DoctorAppointmentData(
      initials: 'EO',
      patientName: 'Elvin Orucov',
      fin: 'FIN: 2QW6610',
      status: 'T\u{0259}sdiql\u{0259}ndi',
      statusColor: AppColors.success,
      statusBg: AppColors.successLight,
      reason: 'EKQ n\u{0259}tic\u{0259}l\u{0259}ri',
      date: '10 May 2026',
      time: '16:15',
      room: 'Kabin\u{0259} 204',
      code: 'AZ-004901',
    ),
  ];

  List<_DoctorAppointmentData> get _visibleAppointments {
    if (_tab == 0) {
      return _appointments.where((item) => item.date == 'Bug\u{00FC}n').toList();
    }
    if (_tab == 1) {
      return _appointments.where((item) => item.date != 'Bug\u{00FC}n').toList();
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        body: Column(
          children: [
            _buildHeader(context),
            _buildStats(context),
            Expanded(
              child: _visibleAppointments.isEmpty
                  ? _buildEmpty(context)
                  : _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tabs = [
      context.tr('Bug\u{00FC}n'),
      context.tr('Yax\u{0131}nla\u{015F}an'),
      context.tr('Tamamlanm\u{0131}\u{015F}'),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient,
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Randevular'),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryMid,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr(
                        'Sizin q\u{0259}bulunuza yaz\u{0131}lan pasiyentl\u{0259}r',
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8FAAC7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surface600,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = _tab == index;
                return GestureDetector(
                  onTap: () => setState(() => _tab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: selected
                          ? null
                          : Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: selected ? AppColors.textPrimary : AppColors.textLight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              value: '6',
              label: context.tr('Bu g\u{00FC}n q\u{0259}bul'),
              icon: Icons.people_alt_outlined,
              color: AppColors.primary,
              bg: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              value: '2',
              label: context.tr('Yeni randevu'),
              icon: Icons.notification_add_outlined,
              color: AppColors.amber,
              bg: AppColors.amberLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _visibleAppointments.length,
      itemBuilder: (context, index) => _DoctorAppointmentCard(
        item: _visibleAppointments[index],
        onDetails: () => _showDetails(context, _visibleAppointments[index]),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_available_outlined,
            size: 48,
            color: AppColors.textDimmed,
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('Bu b\u{00F6}lm\u{0259}d\u{0259} randevu yoxdur'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, _DoctorAppointmentData item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              item.patientName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.fin,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            _DetailLine(
              icon: Icons.access_time_outlined,
              label: context.tr('Vaxt'),
              value: '${context.tr(item.date)} ${item.time}',
            ),
            _DetailLine(
              icon: Icons.meeting_room_outlined,
              label: context.tr('Kabin\u{0259}'),
              value: item.room,
            ),
            _DetailLine(
              icon: Icons.monitor_heart_outlined,
              label: context.tr('M\u{00FC}raci\u{0259}t s\u{0259}b\u{0259}bi'),
              value: item.reason,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _SheetButton(
                    label: context.tr('Mesaj yaz'),
                    icon: Icons.chat_bubble_outline_rounded,
                    bg: AppColors.primaryLight,
                    fg: AppColors.primary,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SheetButton(
                    label: context.tr('Q\u{0259}bula al'),
                    icon: Icons.done_rounded,
                    bg: AppColors.successLight,
                    fg: AppColors.success,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAppointmentCard extends StatelessWidget {
  final _DoctorAppointmentData item;
  final VoidCallback onDetails;

  const _DoctorAppointmentCard({
    required this.item,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: AppColors.primary,
                child: Text(
                  item.initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.fin,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: item.statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.tr(item.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: item.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  '${context.tr(item.date)} ${item.time}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSub,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.meeting_room_outlined,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.room,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSub,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.reason,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onDetails,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    context.tr('Detallar'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSub,
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

class _DetailLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.bgSubtle,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
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

class _SheetButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _SheetButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 19),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAppointmentData {
  final String initials;
  final String patientName;
  final String fin;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String reason;
  final String date;
  final String time;
  final String room;
  final String code;

  const _DoctorAppointmentData({
    required this.initials,
    required this.patientName,
    required this.fin,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.reason,
    required this.date,
    required this.time,
    required this.room,
    required this.code,
  });
}
