import '../../../core/models/account_user.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/auth_session.dart';

class AccountsApi {
  final ApiClient _client;
  final AuthSession _session;

  AccountsApi({
    ApiClient? client,
    AuthSession? session,
  })  : _client = client ?? ApiClient(session: session),
        _session = session ?? AuthSession();

  Future<void> registerCitizen({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String finCode,
    required String password,
    required String password2,
  }) async {
    await _client.post(
      '/api/accounts/register/',
      body: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'fin_code': finCode,
        'password': password,
        'password2': password2,
      },
    );
  }

  Future<AccountUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      '/api/accounts/login/',
      body: {
        'email': email,
        'password': password,
      },
    ) as Map<String, dynamic>;

    await _session.saveTokens(
      access: response['access'] as String,
      refresh: response['refresh'] as String,
    );

    return me();
  }

  Future<AccountUser> me() async {
    final response = await _client.get(
      '/api/accounts/me/',
      authenticated: true,
    ) as Map<String, dynamic>;
    return AccountUser.fromJson(response);
  }

  Future<void> updateMe({
    String? firstName,
    String? lastName,
    String? phone,
    String? finCode,
  }) async {
    final body = <String, dynamic>{};
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (phone != null) body['phone'] = phone;
    if (finCode != null) body['fin_code'] = finCode;

    await _client.patch('/api/accounts/me/', body: body, authenticated: true);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _client.post(
      '/api/accounts/change-password/',
      body: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
      authenticated: true,
    );
  }

  Future<void> logout() async {
    final refresh = await _session.refreshToken;
    if (refresh != null && refresh.isNotEmpty) {
      await _client.post(
        '/api/accounts/logout/',
        body: {'refresh': refresh},
        authenticated: true,
      );
    }
    await _session.clear();
  }

  Future<void> clearSession() => _session.clear();
}
