import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'token_storage.dart';

class ApiService {
  // Отправка кода на email
  static Future<Map<String, dynamic>> sendVerificationCode({
    required String email,
    bool isParentEmail = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sendCode}'),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'isParentEmail': isParentEmail}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка отправки кода: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  // Подтверждение кода
  static Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String code,
    bool isParentEmail = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifyCode}'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'email': email,
          'code': code,
          'isParentEmail': isParentEmail,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Неверный код: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка проверки кода: $e');
    }
  }

  // Регистрация
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String passwordRepeat,
    required String fullName,
    required String dateOfBirth,
    required String gender,
    required List<String> interests,
    required String registrationGoal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'passwordRepeat': passwordRepeat,
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'interests': interests,
          'registrationGoal': registrationGoal,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Сохраняем токен если он есть
        if (data['data']?['token'] != null) {
          await TokenStorage.saveToken(data['data']['token']);
        }
        return data;
      } else {
        throw Exception('Ошибка регистрации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка регистрации: $e');
    }
  }

  // Вход
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Сохраняем токен
        if (data['data']?['token'] != null) {
          await TokenStorage.saveToken(data['data']['token']);
        }
        return data;
      } else {
        throw Exception('Неверные данные: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  // Получить текущего пользователя
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getCurrentUser}'),
        headers: ApiConfig.headersWithToken(token),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        await TokenStorage.deleteToken();
        throw Exception('Токен истёк');
      } else {
        throw Exception('Ошибка получения пользователя: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка: $e');
    }
  }

  // Выход
  static Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
