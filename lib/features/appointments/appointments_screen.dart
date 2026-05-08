import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/localization/app_language.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _tab = 0;

  static const _appointments = [
    _ApptData(
      initials: 'NA',
      avatarColor: Color(0xFF1746A2),
      name: 'Dr. Nigar Abbasova',
      specialty: 'Kardioloq',
      status: 'Təsdiqləndi',
      statusColor: Color(0xFF0B7A4A),
      statusBg: Color(0xFFD6F5E8),
      hospital: 'Bakı Şəhər Klinik Xəstəxanası',
      date: '8 May 2026',
      time: '09:30',
      code: 'AZ-004821',
    ),
    _ApptData(
      initials: 'LH',
      avatarColor: Color(0xFF0D7A5F),
      name: 'Dr. Leyla Həsənova',
      specialty: 'Nevroloq',
      status: 'Gözlənilir',
      statusColor: Color(0xFF9A5200),
      statusBg: Color(0xFFFEF0D6),
      hospital: 'RKX — Respublika Klinik',
      date: '15 May 2026',
      time: '14:00',
      code: 'AZ-004892',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F5FF),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _tab == 0 ? _buildList() : _buildEmpty(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tabs = [
      context.tr('Aktiv'),
      context.tr('Keçmiş'),
      context.tr('Ləğv edilmiş'),
    ];
    final canPop = Navigator.canPop(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF040E1C), Color(0xFF0D2240)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 14,
        16,
        16,
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (canPop)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF132D54),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                )
              else
                const SizedBox(width: 40),
              Expanded(
                child: Text(
                  context.tr('Növbələrim'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            height: 40,
            child: Row(
              children: List.generate(tabs.length, (i) {
                final sel = i == _tab;
                return GestureDetector(
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: sel
                          ? null
                          : Border.all(
                              color: const Color(0xFF1F3D5E).withValues(alpha: 0.4),
                              width: 1,
                            ),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                        color: sel
                            ? const Color(0xFF0B1829)
                            : const Color(0xFF6B8CB8),
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

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _appointments.length,
      itemBuilder: (_, i) => _AppointmentCard(data: _appointments[i]),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 48,
            color: Color(0xFFCBD8E5),
          ),
          const SizedBox(height: 14),
          Text(
            context.tr('Növbə tapılmadı'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7D93AB),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _ApptData data;

  const _AppointmentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x080B1829),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: data.avatarColor,
                child: Text(
                  data.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            data.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0B1829),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: data.statusBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            context.tr(data.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: data.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.specialty,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D93AB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Xəstəxana'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D93AB),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.hospital,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0B1829),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Color(0xFF7D93AB),
              ),
              const SizedBox(width: 5),
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C4159),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_outlined,
                size: 15,
                color: Color(0xFF7D93AB),
              ),
              const SizedBox(width: 5),
              Text(
                data.time,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C4159),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                '#',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF7D93AB),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  data.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C4159),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: context.tr('Detallar'),
                  bg: const Color(0xFFEFF6FF),
                  fg: const Color(0xFF1B4FD8),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: context.tr('Ləğv Et'),
                  bg: const Color(0xFFFFECEC),
                  fg: const Color(0xFFD42B2B),
                  onTap: () => _showCancelDialog(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.event_busy_outlined,
                  color: Color(0xFFD42B2B),
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.tr('Növbəni ləğv etmək istəyirsiniz?'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0B1829),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('Bu əməliyyat geri alına bilməz.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D93AB),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD42B2B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.tr('Bəli, Ləğv Et'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.tr('Geri Qayıt'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C4159),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _ApptData {
  final String initials;
  final Color avatarColor;
  final String name;
  final String specialty;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String hospital;
  final String date;
  final String time;
  final String code;

  const _ApptData({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.specialty,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.hospital,
    required this.date,
    required this.time,
    required this.code,
  });
}
