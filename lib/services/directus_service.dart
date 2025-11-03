import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectusService {
  static const String baseUrl = 'http://localhost:8055';
  
  // Получить все статьи
  static Future<List<Map<String, dynamic>>> getArticles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/articles?sort=-date_created'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }
      throw Exception('Failed to load articles');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить статью по ID
  static Future<Map<String, dynamic>> getArticle(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/articles/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      throw Exception('Failed to load article');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить всех психологов
  static Future<List<Map<String, dynamic>>> getPsychologists() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/psychologists?filter[is_active][_eq]=true'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }
      throw Exception('Failed to load psychologists');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить URL изображения
  static String getImageUrl(String fileId) {
    return '$baseUrl/assets/$fileId';
  }

  // Поиск статей
  static Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/articles?search=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }
      throw Exception('Failed to search articles');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Получить статьи по категории
  static Future<List<Map<String, dynamic>>> getArticlesByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/items/articles?filter[category][_eq]=$category',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data']);
      }
      throw Exception('Failed to load articles by category');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}