enum AppUserRole {
  patient,
  doctor,
}

extension AppUserRoleApi on AppUserRole {
  static AppUserRole fromApi(String value) {
    return value == 'doctor' ? AppUserRole.doctor : AppUserRole.patient;
  }

  String get apiValue {
    return switch (this) {
      AppUserRole.doctor => 'doctor',
      AppUserRole.patient => 'citizen',
    };
  }
}
