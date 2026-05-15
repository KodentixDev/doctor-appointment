import '../../../core/network/api_client.dart';
import '../../../core/services/auth_session.dart';

class AppNotification {
  final int id;
  final String notificationType;
  final String notificationTypeDisplay;
  final String title;
  final String body;
  bool isRead;
  final String? link;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.notificationType,
    required this.notificationTypeDisplay,
    required this.title,
    required this.body,
    required this.isRead,
    this.link,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: _asInt(json['id']),
      notificationType: _asString(json['notification_type']),
      notificationTypeDisplay: _asString(json['notification_type_display']),
      title: _asString(json['title']),
      body: _asString(json['body']),
      isRead: json['is_read'] as bool? ?? false,
      link: json['link']?.toString(),
      createdAt: _asString(json['created_at']),
    );
  }
}

class NotificationsApi {
  final ApiClient _client;

  NotificationsApi({ApiClient? client, AuthSession? session})
    : _client = client ?? ApiClient(session: session);

  Future<List<AppNotification>> list({bool? isRead}) async {
    final params = <String, String>{};
    if (isRead != null) params['is_read'] = isRead.toString();
    final response = await _client.get(
      '/api/notifications/',
      queryParameters: params.isEmpty ? {} : params,
      authenticated: true,
    );
    final items = switch (response) {
      List<dynamic> v => v,
      Map<String, dynamic> v => v['results'] as List<dynamic>? ?? [],
      _ => <dynamic>[],
    };
    return items
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
  }

  Future<int> unreadCount() async {
    final response =
        await _client.get(
              '/api/notifications/unread-count/',
              authenticated: true,
            )
            as Map<String, dynamic>;
    return _asInt(response['count']);
  }

  Future<void> markAllRead() async {
    await _client.post(
      '/api/notifications/mark-all-read/',
      body: {},
      authenticated: true,
    );
  }

  Future<void> markRead(int id) async {
    await _client.post(
      '/api/notifications/$id/read/',
      body: {},
      authenticated: true,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _asString(dynamic value) => value?.toString() ?? '';
