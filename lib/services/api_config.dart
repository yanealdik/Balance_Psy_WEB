class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api';

  // Endpoints
  static const String sendCode = '/auth/send-code';
  static const String verifyCode = '/auth/verify-code';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getCurrentUser = '/users/me';
  static const String updateProfile = '/users/me';
  static const String changePassword = '/users/me/password';
  static const String uploadAvatar = '/users/me/avatar';
  static const String deleteAccount = '/users/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithToken(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
