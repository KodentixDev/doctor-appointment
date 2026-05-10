import 'app_user_role.dart';

class AccountUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final AppUserRole role;
  final String phone;
  final String finCode;

  const AccountUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phone,
    required this.finCode,
  });

  factory AccountUser.fromJson(Map<String, dynamic> json) {
    return AccountUser(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      role: AppUserRoleApi.fromApi(json['role'] as String? ?? 'citizen'),
      phone: json['phone'] as String? ?? '',
      finCode: json['fin_code'] as String? ?? '',
    );
  }

  String get fullName {
    final value = '$firstName $lastName'.trim();
    return value.isEmpty ? email : value;
  }

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    final value = '$first$last'.toUpperCase();
    return value.isEmpty ? 'HN' : value;
  }
}
