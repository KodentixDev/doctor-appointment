class Appointment {
  final int id;
  final int citizen;
  final String citizenName;
  final int doctor;
  final String doctorName;
  final int hospitalId;
  final String hospitalName;
  final String departmentName;
  final String appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String statusDisplay;
  final String notes;
  final String cancellationReason;
  final bool isCancellable;
  final String createdAt;
  final String updatedAt;

  const Appointment({
    required this.id,
    required this.citizen,
    required this.citizenName,
    required this.doctor,
    required this.doctorName,
    required this.hospitalId,
    required this.hospitalName,
    required this.departmentName,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.statusDisplay,
    required this.notes,
    required this.cancellationReason,
    required this.isCancellable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int? ?? 0,
      citizen: json['citizen'] as int? ?? 0,
      citizenName: json['citizen_name'] as String? ?? '',
      doctor: json['doctor'] as int? ?? 0,
      doctorName: json['doctor_name'] as String? ?? '',
      hospitalId: json['hospital_id'] as int? ?? 0,
      hospitalName: json['hospital_name'] as String? ?? '',
      departmentName: json['department_name'] as String? ?? '',
      appointmentDate: json['appointment_date'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusDisplay: json['status_display'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      cancellationReason: json['cancellation_reason'] as String? ?? '',
      isCancellable: json['is_cancellable'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  String get displayStatus {
    if (statusDisplay.isNotEmpty) return statusDisplay;
    return switch (status) {
      'pending' => 'Gözlənilir',
      'confirmed' => 'Təsdiqləndi',
      'completed' => 'Tamamlanmış',
      'cancelled' => 'Ləğv edilmiş',
      'no_show' => 'Gəlmədi',
      _ => status,
    };
  }

  static const _months = [
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

  String get formattedDate {
    return formattedDateWith((value) => value);
  }

  String formattedDateWith(String Function(String value) translate) {
    final parts = appointmentDate.split('-');
    if (parts.length != 3) return appointmentDate;
    final day = int.tryParse(parts[2]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 1;
    final monthIndex = month.clamp(1, 12) - 1;
    final year = parts[0];
    return '$day ${translate(_months[monthIndex])} $year';
  }

  String get formattedTime =>
      startTime.length >= 5 ? startTime.substring(0, 5) : startTime;

  bool get isToday {
    final now = DateTime.now();
    final parts = appointmentDate.split('-');
    if (parts.length != 3) return false;
    return int.tryParse(parts[0]) == now.year &&
        int.tryParse(parts[1]) == now.month &&
        int.tryParse(parts[2]) == now.day;
  }

  String get doctorInitials {
    final name = doctorName.replaceFirst('Dr. ', '').trim();
    final parts = name.split(' ');
    final first = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$first$last'.toUpperCase().isEmpty
        ? 'DR'
        : '$first$last'.toUpperCase();
  }

  String get citizenInitials {
    final parts = citizenName.trim().split(' ');
    final first = parts.isNotEmpty && parts[0].isNotEmpty ? parts[0][0] : '';
    final last = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return '$first$last'.toUpperCase().isEmpty
        ? 'HN'
        : '$first$last'.toUpperCase();
  }
}
