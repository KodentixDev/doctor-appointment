import '../../../core/network/api_client.dart';
import '../../../core/services/auth_session.dart';

class HospitalsApi {
  final ApiClient _client;

  HospitalsApi({ApiClient? client, AuthSession? session})
    : _client = client ?? ApiClient(session: session);

  Future<List<HospitalCity>> cities() async {
    final items = await _getAll('/api/hospitals/cities/');
    return items.map((item) => HospitalCity.fromJson(item)).toList();
  }

  Future<List<HospitalInfo>> hospitals({int? cityId, String? search}) async {
    final items = await _getAll(
      '/api/hospitals/hospitals/',
      queryParameters: {
        if (cityId != null) 'city': cityId.toString(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return items.map((item) => HospitalInfo.fromJson(item)).toList();
  }

  Future<List<HospitalDepartment>> departments({int? hospitalId}) async {
    final items = await _getAll(
      '/api/hospitals/departments/',
      queryParameters: {
        if (hospitalId != null) 'hospital': hospitalId.toString(),
      },
    );
    return items.map((item) => HospitalDepartment.fromJson(item)).toList();
  }

  Future<List<HospitalDoctor>> doctors({
    int? hospitalId,
    int? departmentId,
    String? search,
  }) async {
    final items = await _getAll(
      '/api/hospitals/doctors/',
      queryParameters: {
        if (hospitalId != null) 'hospital': hospitalId.toString(),
        if (departmentId != null) 'department': departmentId.toString(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return items.map((item) => HospitalDoctor.fromJson(item)).toList();
  }

  Future<HospitalDoctor> doctor(int id) async {
    final response =
        await _client.get('/api/hospitals/doctors/$id/')
            as Map<String, dynamic>;
    return HospitalDoctor.fromJson(response);
  }

  Future<HospitalDoctor> doctorProfile() async {
    final response =
        await _client.get('/api/hospitals/doctor/profile/', authenticated: true)
            as Map<String, dynamic>;
    return HospitalDoctor.fromJson(response);
  }

  Future<HospitalDoctor> updateDoctorProfile({
    String? specialization,
    String? bio,
  }) async {
    final body = <String, dynamic>{};
    if (specialization != null) body['specialization'] = specialization;
    if (bio != null) body['bio'] = bio;

    final response =
        await _client.patch(
              '/api/hospitals/doctor/profile/',
              body: body,
              authenticated: true,
            )
            as Map<String, dynamic>;
    return HospitalDoctor.fromJson(response);
  }

  Future<List<HospitalTimeSlot>> doctorSchedules() async {
    final response = await _client.get(
      '/api/hospitals/doctor/schedules/',
      authenticated: true,
    );
    return _items(
      response,
    ).map((item) => HospitalTimeSlot.fromJson(item)).toList();
  }

  Future<HospitalTimeSlot> createDoctorSchedule({
    required int weekday,
    required String startTime,
    required String endTime,
  }) async {
    final response =
        await _client.post(
              '/api/hospitals/doctor/schedules/',
              body: {
                'weekday': weekday,
                'start_time': _timeForApi(startTime),
                'end_time': _timeForApi(endTime),
              },
              authenticated: true,
            )
            as Map<String, dynamic>;
    return HospitalTimeSlot.fromJson(response);
  }

  Future<HospitalTimeSlot> doctorSchedule(int id) async {
    final response =
        await _client.get(
              '/api/hospitals/doctor/schedules/$id/',
              authenticated: true,
            )
            as Map<String, dynamic>;
    return HospitalTimeSlot.fromJson(response);
  }

  Future<HospitalTimeSlot> updateDoctorSchedule({
    required int id,
    int? weekday,
    String? startTime,
    String? endTime,
  }) async {
    final body = <String, dynamic>{};
    if (weekday != null) body['weekday'] = weekday;
    if (startTime != null) body['start_time'] = _timeForApi(startTime);
    if (endTime != null) body['end_time'] = _timeForApi(endTime);

    final response =
        await _client.patch(
              '/api/hospitals/doctor/schedules/$id/',
              body: body,
              authenticated: true,
            )
            as Map<String, dynamic>;
    return HospitalTimeSlot.fromJson(response);
  }

  Future<void> deleteDoctorSchedule(int id) async {
    await _client.delete(
      '/api/hospitals/doctor/schedules/$id/',
      authenticated: true,
    );
  }

  Future<List<Map<String, dynamic>>> _getAll(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    final allItems = <Map<String, dynamic>>[];

    for (var page = 1; page <= 50; page++) {
      final params = <String, String>{...queryParameters};
      if (page > 1) params['page'] = page.toString();

      final response = await _client.get(path, queryParameters: params);
      allItems.addAll(_items(response));

      if (response is! Map<String, dynamic>) break;
      final next = response['next']?.toString() ?? '';
      if (next.isEmpty) break;
    }

    return allItems;
  }

  List<Map<String, dynamic>> _items(dynamic response) {
    final rawItems = switch (response) {
      List<dynamic> value => value,
      Map<String, dynamic> value => value['results'] as List<dynamic>? ?? [],
      _ => <dynamic>[],
    };
    return rawItems
        .whereType<Map<String, dynamic>>()
        .where((item) => item['is_active'] != false)
        .toList();
  }

  String _timeForApi(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 5) return trimmed.substring(0, 5);
    return trimmed;
  }
}

class HospitalCity {
  final int id;
  final String name;
  final bool isActive;

  const HospitalCity({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory HospitalCity.fromJson(Map<String, dynamic> json) {
    return HospitalCity(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class HospitalInfo {
  final int id;
  final int cityId;
  final String cityName;
  final String name;
  final String address;
  final String phone;
  final String email;
  final bool isActive;
  final String createdAt;

  const HospitalInfo({
    required this.id,
    required this.cityId,
    required this.cityName,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.createdAt,
  });

  factory HospitalInfo.fromJson(Map<String, dynamic> json) {
    return HospitalInfo(
      id: _asInt(json['id']),
      cityId: _asInt(json['city']),
      cityName: _asString(json['city_name']),
      name: _asString(json['name']),
      address: _asString(json['address']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _asString(json['created_at']),
    );
  }
}

class HospitalDepartment {
  final int id;
  final int hospitalId;
  final String hospitalName;
  final String name;
  final String description;
  final bool isActive;

  const HospitalDepartment({
    required this.id,
    required this.hospitalId,
    required this.hospitalName,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory HospitalDepartment.fromJson(Map<String, dynamic> json) {
    return HospitalDepartment(
      id: _asInt(json['id']),
      hospitalId: _asInt(json['hospital']),
      hospitalName: _asString(json['hospital_name']),
      name: _asString(json['name']),
      description: _asString(json['description']),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

class HospitalDoctor {
  final int id;
  final int userId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final int hospitalId;
  final String hospitalName;
  final int departmentId;
  final String departmentName;
  final String specialization;
  final String bio;
  final bool isActive;
  final String createdAt;
  final List<HospitalTimeSlot> timeSlots;

  const HospitalDoctor({
    required this.id,
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.hospitalId,
    required this.hospitalName,
    required this.departmentId,
    required this.departmentName,
    required this.specialization,
    required this.bio,
    required this.isActive,
    required this.createdAt,
    required this.timeSlots,
  });

  factory HospitalDoctor.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final slots = json['time_slots'] as List<dynamic>? ?? [];
    return HospitalDoctor(
      id: _asInt(json['id']),
      userId: _asInt(user['id']),
      email: _asString(user['email']),
      firstName: _asString(user['first_name']),
      lastName: _asString(user['last_name']),
      phone: _asString(user['phone']),
      hospitalId: _asInt(json['hospital']),
      hospitalName: _asString(json['hospital_name']),
      departmentId: _asInt(json['department']),
      departmentName: _asString(json['department_name']),
      specialization: _asString(json['specialization']),
      bio: _asString(json['bio']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _asString(json['created_at']),
      timeSlots: slots
          .whereType<Map<String, dynamic>>()
          .map(HospitalTimeSlot.fromJson)
          .toList(),
    );
  }

  String get name {
    final fullName = [
      firstName,
      lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ').trim();
    if (fullName.isEmpty) return email.isNotEmpty ? email : 'Həkim #$id';
    if (fullName.toLowerCase().startsWith('dr.')) return fullName;
    return 'Dr. $fullName';
  }

  String get specialty {
    if (specialization.isNotEmpty) return specialization;
    return departmentName;
  }
}

class HospitalTimeSlot {
  final int id;
  final int weekday;
  final String weekdayDisplay;
  final String startTime;
  final String endTime;
  final int durationMinutes;

  const HospitalTimeSlot({
    required this.id,
    required this.weekday,
    required this.weekdayDisplay,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
  });

  factory HospitalTimeSlot.fromJson(Map<String, dynamic> json) {
    return HospitalTimeSlot(
      id: _asInt(json['id']),
      weekday: _asInt(json['weekday']),
      weekdayDisplay: _asString(json['weekday_display']),
      startTime: _asString(json['start_time']),
      endTime: _asString(json['end_time']),
      durationMinutes: _asInt(json['duration_minutes']),
    );
  }

  String get shortRange => '${_shortTime(startTime)} - ${_shortTime(endTime)}';

  static String _shortTime(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 5) return trimmed.substring(0, 5);
    return trimmed;
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(dynamic value) => value?.toString() ?? '';
