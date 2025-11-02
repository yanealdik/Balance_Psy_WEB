class ApiConfig {
  // Замените на ваш реальный IP адрес или используйте localhost
  static const String baseUrl = 'http://localhost:8080/api';

  // Endpoints
  static const String sendCode = '/auth/send-code';
  static const String verifyCode = '/auth/verify-code';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getCurrentUser = '/users/me';

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
