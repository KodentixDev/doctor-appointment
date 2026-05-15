enum AppUserRole { citizen, doctor }

extension AppUserRoleApi on AppUserRole {
  static AppUserRole fromApi(String value) {
    return value == 'doctor' ? AppUserRole.doctor : AppUserRole.citizen;
  }

  String get apiValue {
    return switch (this) {
      AppUserRole.doctor => 'doctor',
      AppUserRole.citizen => 'citizen',
    };
  }
}
