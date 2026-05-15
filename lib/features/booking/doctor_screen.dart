import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_language.dart';
import '../../core/widgets/hn_badge.dart';
import '../../core/widgets/step_progress_bar.dart';
import 'datetime_screen.dart';

class DoctorScreen extends StatelessWidget {
  final String specialty;

  const DoctorScreen({super.key, required this.specialty});

  static const _doctorsBySpecialty = {
    'Kardioloq': [
      _DoctorChoice(
        id: 7,
        name: 'Dr. Anar Mammadov',
        hospital: 'Respublika Klinik Xəstəxanası',
        nextSlot: '22 May 2026, 09:00',
        hasAvailability: true,
      ),
      _DoctorChoice(
        id: 1,
        name: 'Dr. Murad Hüseynov',
        hospital: 'Bakı Şəhər Klinik Xəstəxanası',
        nextSlot: '19 May 2026, 10:30',
        hasAvailability: true,
      ),
    ],
    'Nevroloq': [
      _DoctorChoice(
        id: 2,
        name: 'Dr. Leyla Həsənova',
        hospital: 'Bakı Şəhər Klinik Xəstəxanası',
        nextSlot: '15 May 2026, 14:00',
        hasAvailability: true,
      ),
    ],
    'Ortoped': [
      _DoctorChoice(
        id: 3,
        name: 'Dr. Rauf Qasımov',
        hospital: 'Respublika Klinik Xəstəxanası',
        nextSlot: '21 May 2026, 11:00',
        hasAvailability: true,
      ),
    ],
    'Oftalmoloq': [
      _DoctorChoice(
        id: 4,
        name: 'Dr. Aynur Kərimova',
        hospital: 'Klinik Tibbi Mərkəz',
        nextSlot: '26 May 2026, 12:00',
        hasAvailability: true,
      ),
    ],
    'Pulmonoloq': [
      _DoctorChoice(
        id: 5,
        name: 'Dr. Elvin Orucov',
        hospital: 'Mərkəzi Neftçilər Xəstəxanası',
        nextSlot: '28 May 2026, 09:30',
        hasAvailability: true,
      ),
    ],
    'Endokrinoloq': [
      _DoctorChoice(
        id: 6,
        name: 'Dr. Sevinc Aliyeva',
        hospital: 'MedEra Hospital',
        nextSlot: '28 May 2026, 15:00',
        hasAvailability: true,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final doctors = _doctorsBySpecialty[specialty] ?? const <_DoctorChoice>[];

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
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: doctors.length,
                  separatorBuilder: (_, _) => Container(
                    margin: const EdgeInsets.only(left: 76),
                    height: 0.5,
                    color: const Color(0xFFE8EFF8),
                  ),
                  itemBuilder: (ctx, index) =>
                      _DoctorItem(doctor: doctors[index], specialty: specialty),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('Həkim Seçin'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0B1829),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '${context.tr(specialty)} · ${context.tr('Addım 4 — Həkim seçin')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          StepProgressBar(
            current: 3,
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
                  context.tr('Həkim axtar...'),
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

class _DoctorItem extends StatelessWidget {
  final _DoctorChoice doctor;
  final String specialty;

  const _DoctorItem({required this.doctor, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DateTimeScreen(
            doctorId: doctor.id,
            doctorName: doctor.name,
            specialty: specialty,
          ),
        ),
      ),
      child: Container(
        color: doctor.hasAvailability ? const Color(0xFFF0F5FF) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: Text(
                doctor.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0B1829),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${context.tr(specialty)} · ${context.tr(doctor.hospital)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D93AB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${context.tr('İlk boş vaxt:')} ${context.tr(doctor.nextSlot)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (doctor.hasAvailability)
              HnBadge(
                label: context.tr('Boş var'),
                bg: AppColors.successLight,
                fg: AppColors.success,
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD8E5), size: 24),
          ],
        ),
      ),
    );
  }
}

class _DoctorChoice {
  final int id;
  final String name;
  final String hospital;
  final String nextSlot;
  final bool hasAvailability;

  const _DoctorChoice({
    required this.id,
    required this.name,
    required this.hospital,
    required this.nextSlot,
    required this.hasAvailability,
  });

  String get initials {
    final parts = name.replaceFirst('Dr. ', '').trim().split(' ');
    final first = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    final value = '$first$last'.toUpperCase();
    return value.isEmpty ? 'DR' : value;
  }
}
