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
      color: const Color(0xFF071427),
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
                      color: const Color(0xFF162336),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _appointments.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AppointmentCard(data: _appointments[i]),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 40,
            color: Color(0xFFD2DBE7),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('Növbə tapılmadı'),
            style: const TextStyle(
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                Text(
                  context.tr('Xəstəxana'),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B98AA),
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
              Expanded(
                child: Text(
                  data.code,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF344057),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  label: context.tr('Detallar'),
                  bg: const Color(0xFFEAF1FF),
                  fg: const Color(0xFF1A5AD7),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBtn(
                  label: context.tr('Ləğv Et'),
                  bg: const Color(0xFFFFEEEE),
                  fg: const Color(0xFFD93025),
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
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.event_busy_outlined,
                  color: Color(0xFFE53935),
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
                  color: Color(0xFF06152B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr('Bu əməliyyat geri alına bilməz.'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8B98AA),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
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
                    backgroundColor: const Color(0xFFF0F3F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    context.tr('Geri Qayıt'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3D5068),
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
