import '../../../core/models/appointment.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/auth_session.dart';

class AppointmentsApi {
  final ApiClient _client;

  AppointmentsApi({ApiClient? client, AuthSession? session})
      : _client = client ?? ApiClient(session: session);

  Future<List<Appointment>> citizenAppointments({String tab = 'upcoming'}) async {
    final response = await _client.get(
      '/api/appointments/citizen/',
      queryParameters: {'tab': tab},
      authenticated: true,
    ) as Map<String, dynamic>;
    final results = response['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> bookAppointment({
    required int doctorId,
    required String appointmentDate,
    required String startTime,
  }) async {
    final response = await _client.post(
      '/api/appointments/citizen/book/',
      body: {
        'doctor': doctorId,
        'appointment_date': appointmentDate,
        'start_time': startTime,
      },
      authenticated: true,
    ) as Map<String, dynamic>;
    return Appointment.fromJson(response);
  }

  Future<void> cancelAppointment(int id, {String reason = ''}) async {
    await _client.post(
      '/api/appointments/citizen/$id/cancel/',
      body: {'reason': reason},
      authenticated: true,
    );
  }

  Future<List<String>> availableDays(int doctorId) async {
    final response = await _client.get(
      '/api/appointments/doctor/$doctorId/available-days/',
      authenticated: true,
    ) as Map<String, dynamic>;
    return (response['dates'] as List<dynamic>? ?? []).cast<String>();
  }

  Future<List<Map<String, String>>> availableSlots(
      int doctorId, String date) async {
    final response = await _client.get(
      '/api/appointments/doctor/$doctorId/slots/',
      queryParameters: {'date': date},
      authenticated: true,
    ) as Map<String, dynamic>;
    final slots = response['slots'] as List<dynamic>? ?? [];
    return slots.map((s) {
      final slot = s as Map<String, dynamic>;
      return {
        'start': slot['start'] as String? ?? '',
        'end': slot['end'] as String? ?? '',
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
    ) as Map<String, dynamic>;
    final results = response['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
