// lib/services/user_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_config.dart';
import 'token_storage.dart';

class UserService {
  /// Получить текущего пользователя
  static Future<UserModel> getCurrentUser() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден. Пожалуйста, войдите снова.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/me'),
        headers: ApiConfig.headersWithToken(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data']);
        } else {
          throw Exception('Некорректный формат данных от сервера');
        }
      } else if (response.statusCode == 401) {
        await TokenStorage.deleteToken();
        throw Exception('Сессия истекла. Войдите снова.');
      } else {
        throw Exception('Ошибка загрузки профиля: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  /// Обновить профиль пользователя
  static Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? interests,
    String? registrationGoal,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final Map<String, dynamic> body = {};
      if (fullName != null) body['fullName'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (dateOfBirth != null) {
        body['dateOfBirth'] = dateOfBirth.toIso8601String().split('T')[0];
      }
      if (gender != null) body['gender'] = gender;
      if (interests != null) body['interests'] = interests;
      if (registrationGoal != null) body['registrationGoal'] = registrationGoal;

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/me'),
        headers: ApiConfig.headersWithToken(token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data']);
        } else {
          throw Exception('Некорректный ответ сервера');
        }
      } else if (response.statusCode == 401) {
        await TokenStorage.deleteToken();
        throw Exception('Сессия истекла');
      } else {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка обновления профиля');
      }
    } catch (e) {
      throw Exception('Ошибка обновления: $e');
    }
  }

  /// Сменить пароль
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      if (newPassword != confirmPassword) {
        throw Exception('Пароли не совпадают');
      }

      if (newPassword.length < 6) {
        throw Exception('Пароль должен содержать минимум 6 символов');
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/me/password'),
        headers: ApiConfig.headersWithToken(token),
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        await TokenStorage.deleteToken();
        throw Exception('Сессия истекла');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Неверный текущий пароль');
      } else {
        throw Exception('Ошибка смены пароля');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Удалить аккаунт
  static Future<void> deleteAccount(String password) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/users/me'),
        headers: ApiConfig.headersWithToken(token),
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode == 200) {
        await TokenStorage.deleteToken();
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Неверный пароль');
      } else {
        throw Exception('Ошибка удаления аккаунта');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Загрузить аватар
  static Future<String> uploadAvatar(
    Uint8List imageBytes,
    String fileName,
  ) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Токен не найден');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/users/me/avatar'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        http.MultipartFile.fromBytes('avatar', imageBytes, filename: fileName),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data']['avatarUrl'] as String;
      } else {
        throw Exception('Ошибка загрузки аватара');
      }
    } catch (e) {
      throw Exception('Ошибка загрузки: $e');
    }
  }

  /// Запросить сброс пароля
  static Future<void> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/forgot-password'),
        headers: ApiConfig.headers,
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка отправки кода');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  /// Сбросить пароль
  static Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      if (newPassword != confirmPassword) {
        throw Exception('Пароли не совпадают');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/reset-password'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final error = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка сброса пароля');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
