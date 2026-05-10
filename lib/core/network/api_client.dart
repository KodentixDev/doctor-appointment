import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../services/auth_session.dart';
import 'api_exception.dart';

class ApiClient {
  final AuthSession _session;
  final http.Client _httpClient;

  ApiClient({
    AuthSession? session,
    http.Client? httpClient,
  })  : _session = session ?? AuthSession(),
        _httpClient = httpClient ?? http.Client();

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    if (baseUrl.isEmpty) {
      throw const ApiException(
        statusCode: 0,
        message: 'BASE_URL .env faylinda tapilmadi.',
      );
    }

    final base = Uri.parse(baseUrl);
    return base.replace(
      path: _joinPaths(base.path, path),
      queryParameters: queryParameters,
    );
  }

  String _joinPaths(String basePath, String path) {
    final left = basePath.endsWith('/')
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final right = path.startsWith('/') ? path.substring(1) : path;
    return '$left/$right';
  }

  Future<Map<String, String>> _headers({bool authenticated = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (authenticated) {
      final token = await _session.accessToken;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = false,
  }) async {
    final response = await _httpClient.get(
      _uri(path, queryParameters),
      headers: await _headers(authenticated: authenticated),
    );
    return _decode(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final response = await _httpClient.post(
      _uri(path),
      headers: await _headers(authenticated: authenticated),
      body: jsonEncode(body ?? {}),
    );
    return _decode(response);
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
  }) async {
    final response = await _httpClient.patch(
      _uri(path),
      headers: await _headers(authenticated: authenticated),
      body: jsonEncode(body ?? {}),
    );
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final raw = response.body.trim();
    final data = raw.isEmpty ? null : jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: _extractMessage(data),
      details: data,
    );
  }

  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) return detail;

      for (final entry in data.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          return '${entry.key}: ${value.first}';
        }
        if (value is String && value.isNotEmpty) {
          return '${entry.key}: $value';
        }
      }
    }
    return 'Sorğu icra olunmadı.';
  }
}
