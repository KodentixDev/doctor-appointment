import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../core/services/auth_session.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class MedicalProfile {
  final String bloodType;
  final String allergies;
  final String chronicDiseases;
  final String currentMedications;
  final String emergencyContactName;
  final String emergencyContactPhone;

  const MedicalProfile({
    this.bloodType = '',
    this.allergies = '',
    this.chronicDiseases = '',
    this.currentMedications = '',
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
  });

  MedicalProfile copyWith({
    String? bloodType,
    String? allergies,
    String? chronicDiseases,
    String? currentMedications,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return MedicalProfile(
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      currentMedications: currentMedications ?? this.currentMedications,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}

class SurgeryRecord {
  final int id;
  final String name;
  final String date;
  final String hospital;
  final String notes;

  const SurgeryRecord({
    required this.id,
    required this.name,
    required this.date,
    required this.hospital,
    required this.notes,
  });
}

class DiagnosisRecord {
  final int id;
  final String name;
  final String date;
  final String doctorName;
  final String notes;

  const DiagnosisRecord({
    required this.id,
    required this.name,
    required this.date,
    required this.doctorName,
    required this.notes,
  });
}

class MedicalData {
  final MedicalProfile profile;
  final List<SurgeryRecord> surgeries;
  final List<DiagnosisRecord> diagnoses;

  const MedicalData({
    required this.profile,
    required this.surgeries,
    required this.diagnoses,
  });
}

// ── API ───────────────────────────────────────────────────────────────────────

class MedicalRecordsApi {
  final AuthSession _session;
  final http.Client _http;

  MedicalRecordsApi({AuthSession? session, http.Client? httpClient})
    : _session = session ?? AuthSession(),
      _http = httpClient ?? http.Client();

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

  Future<Map<String, String>> _headers({String? csrfToken}) async {
    final token = await _session.accessToken ?? '';
    final headers = <String, String>{'Authorization': 'Bearer $token'};
    if (csrfToken != null) {
      headers['X-CSRFToken'] = csrfToken;
      headers['Cookie'] = 'csrftoken=$csrfToken';
    }
    return headers;
  }

  /// GET /medical/ — returns raw HTML. Extracts CSRF token and medical data.
  Future<_PageData> _getPage() async {
    final uri = Uri.parse('$_baseUrl/medical/');
    final response = await _http.get(uri, headers: await _headers());

    if (response.statusCode == 302 || response.statusCode == 301) {
      throw const MedicalApiException('Giriş tələb olunur. Yenidən daxil olun.');
    }
    if (response.statusCode != 200) {
      throw MedicalApiException(
        'Tibbi məlumatlar yüklənmədi (${response.statusCode}).',
      );
    }

    final html = utf8.decode(response.bodyBytes);
    final csrf = _extractCsrf(response.headers['set-cookie'] ?? '', html);
    return _PageData(html: html, csrfToken: csrf ?? '');
  }

  Future<MedicalData> load() async {
    final page = await _getPage();
    return _PageParser.parse(page.html);
  }

  Future<void> updateProfile(MedicalProfile profile) async {
    final page = await _getPage();
    final uri = Uri.parse('$_baseUrl/medical/');
    final body = {
      'csrfmiddlewaretoken': page.csrfToken,
      'blood_type': profile.bloodType,
      'allergies': profile.allergies,
      'chronic_diseases': profile.chronicDiseases,
      'current_medications': profile.currentMedications,
      'emergency_contact_name': profile.emergencyContactName,
      'emergency_contact_phone': profile.emergencyContactPhone,
    };
    await _formPost(uri, body, page.csrfToken);
  }

  Future<void> addSurgery({
    required String name,
    required String date,
    required String hospital,
    required String notes,
  }) async {
    final page = await _getPage();
    final uri = Uri.parse('$_baseUrl/medical/surgery/add/');
    await _formPost(
      uri,
      {
        'csrfmiddlewaretoken': page.csrfToken,
        'name': name,
        'date': date,
        'hospital': hospital,
        'notes': notes,
      },
      page.csrfToken,
    );
  }

  Future<void> deleteSurgery(int pk) async {
    final page = await _getPage();
    final uri = Uri.parse('$_baseUrl/medical/surgery/$pk/delete/');
    await _formPost(uri, {'csrfmiddlewaretoken': page.csrfToken}, page.csrfToken);
  }

  Future<void> addDiagnosis({
    required String name,
    required String date,
    required String doctorName,
    required String notes,
  }) async {
    final page = await _getPage();
    final uri = Uri.parse('$_baseUrl/medical/diagnosis/add/');
    await _formPost(
      uri,
      {
        'csrfmiddlewaretoken': page.csrfToken,
        'name': name,
        'date': date,
        'doctor_name': doctorName,
        'notes': notes,
      },
      page.csrfToken,
    );
  }

  Future<void> deleteDiagnosis(int pk) async {
    final page = await _getPage();
    final uri = Uri.parse('$_baseUrl/medical/diagnosis/$pk/delete/');
    await _formPost(uri, {'csrfmiddlewaretoken': page.csrfToken}, page.csrfToken);
  }

  Future<void> _formPost(
    Uri uri,
    Map<String, String> body,
    String csrfToken,
  ) async {
    final headers = await _headers(csrfToken: csrfToken);
    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    final response = await _http.post(uri, headers: headers, body: body);

    if (response.statusCode >= 400) {
      throw MedicalApiException('Əməliyyat yerinə yetirilmədi (${response.statusCode}).');
    }
  }

  String? _extractCsrf(String setCookieHeader, String html) {
    // Try Set-Cookie header first
    final cookieMatch = RegExp(r'csrftoken=([^;]+)').firstMatch(setCookieHeader);
    if (cookieMatch != null) return cookieMatch.group(1);

    // Fallback: look for csrfmiddlewaretoken in HTML
    final htmlMatch =
        RegExp(r'csrfmiddlewaretoken["\s]+value="([^"]+)"').firstMatch(html);
    return htmlMatch?.group(1);
  }
}

// ── HTML Parser ───────────────────────────────────────────────────────────────

class _PageData {
  final String html;
  final String csrfToken;

  const _PageData({required this.html, required this.csrfToken});
}

class _PageParser {
  static MedicalData parse(String html) {
    return MedicalData(
      profile: _parseProfile(html),
      surgeries: _parseSurgeries(html),
      diagnoses: _parseDiagnoses(html),
    );
  }

  static String _field(String html, String name) {
    // <input ... name="field" value="...">
    final inputMatch = RegExp(
      'name="$name"[^>]*value="([^"]*)"',
      caseSensitive: false,
    ).firstMatch(html);
    if (inputMatch != null) return _decode(inputMatch.group(1) ?? '');

    // <input ... value="..." name="field">
    final inputMatch2 = RegExp(
      'value="([^"]*)"[^>]*name="$name"',
      caseSensitive: false,
    ).firstMatch(html);
    if (inputMatch2 != null) return _decode(inputMatch2.group(1) ?? '');

    // <textarea name="field">...</textarea>
    final textareaMatch = RegExp(
      '<textarea[^>]*name="$name"[^>]*>([\\s\\S]*?)</textarea>',
      caseSensitive: false,
    ).firstMatch(html);
    if (textareaMatch != null) return _decode(textareaMatch.group(1)?.trim() ?? '');

    return '';
  }

  static MedicalProfile _parseProfile(String html) {
    return MedicalProfile(
      bloodType: _field(html, 'blood_type'),
      allergies: _field(html, 'allergies'),
      chronicDiseases: _field(html, 'chronic_diseases'),
      currentMedications: _field(html, 'current_medications'),
      emergencyContactName: _field(html, 'emergency_contact_name'),
      emergencyContactPhone: _field(html, 'emergency_contact_phone'),
    );
  }

  static List<SurgeryRecord> _parseSurgeries(String html) {
    final results = <SurgeryRecord>[];
    // Typical Django form row: data-pk or action="/medical/surgery/N/delete/"
    final deletePattern = RegExp(r'/medical/surgery/(\d+)/delete/');
    final matches = deletePattern.allMatches(html);
    for (final m in matches) {
      final id = int.tryParse(m.group(1) ?? '') ?? 0;
      // Try to extract surgery info near the delete link
      final start = (m.start - 400).clamp(0, html.length);
      final snippet = html.substring(start, m.start);
      results.add(
        SurgeryRecord(
          id: id,
          name: _snippetField(snippet, 'name') ,
          date: _snippetField(snippet, 'date'),
          hospital: _snippetField(snippet, 'hospital'),
          notes: _snippetField(snippet, 'notes'),
        ),
      );
    }
    return results;
  }

  static List<DiagnosisRecord> _parseDiagnoses(String html) {
    final results = <DiagnosisRecord>[];
    final deletePattern = RegExp(r'/medical/diagnosis/(\d+)/delete/');
    final matches = deletePattern.allMatches(html);
    for (final m in matches) {
      final id = int.tryParse(m.group(1) ?? '') ?? 0;
      final start = (m.start - 400).clamp(0, html.length);
      final snippet = html.substring(start, m.start);
      results.add(
        DiagnosisRecord(
          id: id,
          name: _snippetField(snippet, 'name'),
          date: _snippetField(snippet, 'date'),
          doctorName: _snippetField(snippet, 'doctor_name'),
          notes: _snippetField(snippet, 'notes'),
        ),
      );
    }
    return results;
  }

  static String _snippetField(String snippet, String key) {
    // Look for data-key="value" or just the last text before a tag
    final m = RegExp('$key[^"]*"([^"]*)"').firstMatch(snippet);
    return _decode(m?.group(1) ?? '');
  }

  static String _decode(String s) => s
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#x27;', "'");
}

// ── Exception ─────────────────────────────────────────────────────────────────

class MedicalApiException implements Exception {
  final String message;

  const MedicalApiException(this.message);

  @override
  String toString() => message;
}
