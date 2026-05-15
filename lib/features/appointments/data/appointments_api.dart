import '../../../core/models/appointment.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/auth_session.dart';

class AppointmentsApi {
  final ApiClient _client;

  AppointmentsApi({ApiClient? client, AuthSession? session})
    : _client = client ?? ApiClient(session: session);

  Future<List<Appointment>> citizenAppointments({
    String tab = 'upcoming',
  }) async {
    final response = await _client.get(
      '/api/appointments/citizen/',
      queryParameters: {'tab': tab},
      authenticated: true,
    );
    return _parseAppointments(response);
  }

  Future<Appointment> citizenAppointmentDetail(int id) async {
    final response =
        await _client.get('/api/appointments/citizen/$id/', authenticated: true)
            as Map<String, dynamic>;
    return Appointment.fromJson(response);
  }

  Future<Appointment> bookAppointment({
    required int doctorId,
    required String appointmentDate,
    required String startTime,
  }) async {
    final response =
        await _client.post(
              '/api/appointments/citizen/book/',
              body: {
                'doctor': doctorId,
                'appointment_date': appointmentDate,
                'start_time': _timeForApi(startTime),
              },
              authenticated: true,
            )
            as Map<String, dynamic>;
    return Appointment.fromJson(response);
  }

  Future<String> cancelAppointment(int id, {String reason = ''}) async {
    final response =
        await _client.post(
              '/api/appointments/citizen/$id/cancel/',
              body: {'reason': reason},
              authenticated: true,
            )
            as Map<String, dynamic>;
    return response['detail'] as String? ?? '';
  }

  Future<List<String>> availableDays(int doctorId) async {
    final response = await _client.get(
      '/api/appointments/doctor/$doctorId/available-days/',
      authenticated: true,
    );
    final dates = switch (response) {
      List<dynamic> value => value,
      Map<String, dynamic> value => value['dates'] as List<dynamic>? ?? [],
      _ => <dynamic>[],
    };
    return dates.map((date) => date.toString()).toList();
  }

  Future<List<Map<String, String>>> availableSlots(
    int doctorId,
    String date,
  ) async {
    final response =
        await _client.get(
              '/api/appointments/doctor/$doctorId/slots/',
              queryParameters: {'date': date},
              authenticated: true,
            )
            as Map<String, dynamic>;
    final slots = response['slots'] as List<dynamic>? ?? [];
    return slots.map((s) {
      final slot = s as Map<String, dynamic>;
      return {
        'start': (slot['start'] ?? slot['start_time'] ?? '').toString(),
        'end': (slot['end'] ?? slot['end_time'] ?? '').toString(),
      };
    }).toList();
  }

  Future<List<Appointment>> doctorAppointments({
    String tab = 'upcoming',
    String? date,
  }) async {
    final params = <String, String>{'tab': tab};
    if (date != null) params['date'] = date;
    final response = await _client.get(
      '/api/appointments/doctor/',
      queryParameters: params,
      authenticated: true,
    );
    return _parseAppointments(response);
  }

  Future<Appointment> doctorAppointmentDetail(int id) async {
    final response =
        await _client.get('/api/appointments/doctor/$id/', authenticated: true)
            as Map<String, dynamic>;
    return Appointment.fromJson(response);
  }

  Future<DoctorDashboard> doctorDashboard() async {
    final response =
        await _client.get(
              '/api/appointments/doctor/dashboard/',
              authenticated: true,
            )
            as Map<String, dynamic>;
    return DoctorDashboard.fromJson(response);
  }

  List<Appointment> _parseAppointments(dynamic response) {
    final items = switch (response) {
      List<dynamic> value => value,
      Map<String, dynamic> value => value['results'] as List<dynamic>? ?? [],
      _ => <dynamic>[],
    };
    return items
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _timeForApi(String value) {
    final trimmed = value.trim();
    if (trimmed.length >= 5) return trimmed.substring(0, 5);
    return trimmed;
  }
}

class DoctorDashboard {
  final int total;
  final int today;
  final int pending;
  final int confirmed;
  final List<Appointment> todayAppointments;
  final List<Appointment> upcoming;

  const DoctorDashboard({
    required this.total,
    required this.today,
    required this.pending,
    required this.confirmed,
    required this.todayAppointments,
    required this.upcoming,
  });

  factory DoctorDashboard.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    return DoctorDashboard(
      total: stats['total'] as int? ?? 0,
      today: stats['today'] as int? ?? 0,
      pending: stats['pending'] as int? ?? 0,
      confirmed: stats['confirmed'] as int? ?? 0,
      todayAppointments: _parseDashboardAppointments(
        json['today_appointments'],
      ),
      upcoming: _parseDashboardAppointments(json['upcoming']),
    );
  }

  static List<Appointment> _parseDashboardAppointments(dynamic value) {
    final items = value as List<dynamic>? ?? [];
    return items
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
