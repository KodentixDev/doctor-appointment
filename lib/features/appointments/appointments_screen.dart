import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      statusColor: Color(0xFF137A33),
      statusBg: Color(0xFFDDF9E7),
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
      statusColor: Color(0xFFB46B05),
      statusBg: Color(0xFFFFF1D9),
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
        backgroundColor: const Color(0xFFF0F3F7),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _tab == 0
                  ? _buildList()
                  : _buildEmpty(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tabs = ['Aktiv', 'Keçmiş', 'Ləğv edilmiş'];
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
            'Növbələrim',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFA726),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(tabs.length, (i) {
              final sel = i == _tab;
              return GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: Container(
                  margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: sel
                          ? Colors.white
                          : const Color(0xFF2E4A6E),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: sel
                          ? const Color(0xFF071427)
                          : const Color(0xFF6B8CB8),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: _appointments.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AppointmentCard(data: _appointments[i]),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.event_busy_outlined,
            size: 40,
            color: Color(0xFFD2DBE7),
          ),
          SizedBox(height: 12),
          Text(
            'Növbə tapılmadı',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB7C2D1),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF06152B),
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
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            data.status,
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
                        color: Color(0xFF8B98AA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FA),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xəstəxana',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B98AA),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.hospital,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF06152B),
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
                color: Color(0xFF8090A6),
              ),
              const SizedBox(width: 5),
              Text(
                data.date,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344057),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_outlined,
                size: 15,
                color: Color(0xFF8090A6),
              ),
              const SizedBox(width: 5),
              Text(
                data.time,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344057),
                ),
              ),
              const SizedBox(width: 14),
              const Text(
                '#',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF8090A6),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                data.code,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF344057),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: 'Detallar',
                  bg: const Color(0xFFF2F5FA),
                  fg: const Color(0xFF06152B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: 'Loğv Et',
                  bg: const Color(0xFFFFEEEE),
                  fg: const Color(0xFFD93025),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _ActionBtn({
    required this.label,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: fg,
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
