class ApiEndPoints {
  ApiEndPoints._();

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh-token';

  // User endpoints
  static const String userProfile = '/api/users/me';
  static const String editProfile = '/api/users/edit-profile';
  static const String changePassword = '/api/users/change-password';

  // Service endpoints
  static const String services = '/api/services';
}
