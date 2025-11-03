import 'dart:convert';
import 'package:http/http.dart' as http;

/// Сервис для работы с Directus Headless CMS
/// API Documentation: https://docs.directus.io/reference/introduction.html
class DirectusService {
  static const String baseUrl = 'http://localhost:8055';

  // Если нужна авторизация для приватных коллекций
  static String? _accessToken;

  /// Установить токен доступа (если требуется для админских эндпоинтов)
  static void setAccessToken(String token) {
    _accessToken = token;
  }

  /// Получить заголовки для запроса
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // ========== СТАТЬИ ==========

  /// Получить все статьи
  ///
  /// Параметры:
  /// - [status]: фильтр по статусу (published, draft, archived)
  /// - [category]: фильтр по категории
  /// - [limit]: количество записей (default: 100)
  /// - [sort]: сортировка (default: -published_at)
  static Future<List<Map<String, dynamic>>> getArticles({
    String status = 'published',
    String? category,
    int limit = 100,
    String sort = '-published_at',
  }) async {
    try {
      var url = '$baseUrl/items/articles?limit=$limit&sort=$sort';

      // Фильтр по статусу
      url += '&filter[status][_eq]=$status';

      // Фильтр по категории (опционально)
      if (category != null) {
        url += '&filter[category][_eq]=$category';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to load articles: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

  /// Получить статью по ID
  static Future<Map<String, dynamic>> getArticle(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/articles/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'] as Map<String, dynamic>;
      }
      throw Exception('Failed to load article');
    } catch (e) {
      throw Exception('Error fetching article: $e');
    }
  }

  /// Получить статью по slug (удобнее для SEO)
  static Future<Map<String, dynamic>?> getArticleBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/articles?filter[slug][_eq]=$slug&limit=1'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final articles = List<Map<String, dynamic>>.from(data['data'] ?? []);
        return articles.isNotEmpty ? articles.first : null;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching article by slug: $e');
    }
  }

  /// Увеличить счётчик просмотров статьи
  static Future<void> incrementArticleViews(String id) async {
    try {
      // Сначала получаем текущее количество просмотров
      final article = await getArticle(id);
      final currentViews = article['views'] ?? 0;

      // Обновляем
      await http.patch(
        Uri.parse('$baseUrl/items/articles/$id'),
        headers: _headers,
        body: jsonEncode({'views': currentViews + 1}),
      );
    } catch (e) {
      // Игнорируем ошибку, чтобы не блокировать отображение статьи
      print('Failed to increment views: $e');
    }
  }

  /// Поиск статей по тексту
  static Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/items/articles?search=$query&filter[status][_eq]=published',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to search articles');
    } catch (e) {
      throw Exception('Error searching articles: $e');
    }
  }

  /// Получить статьи по категории
  static Future<List<Map<String, dynamic>>> getArticlesByCategory(
    String category,
  ) async {
    return getArticles(category: category);
  }

  // ========== ПСИХОЛОГИ ==========

  /// Получить всех активных психологов
  static Future<List<Map<String, dynamic>>> getPsychologists({
    bool activeOnly = true,
    String sort = '-rating',
    int limit = 100,
  }) async {
    try {
      var url = '$baseUrl/items/psychologists?limit=$limit&sort=$sort';

      if (activeOnly) {
        url += '&filter[status][_eq]=active';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to load psychologists');
    } catch (e) {
      throw Exception('Error fetching psychologists: $e');
    }
  }

  /// Получить психолога по ID
  static Future<Map<String, dynamic>> getPsychologist(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/psychologists/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'] as Map<String, dynamic>;
      }
      throw Exception('Failed to load psychologist');
    } catch (e) {
      throw Exception('Error fetching psychologist: $e');
    }
  }

  /// Поиск психологов по специализации
  static Future<List<Map<String, dynamic>>> getPsychologistsBySpecialization(
    String specialization,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/items/psychologists?filter[specializations][_contains]=$specialization&filter[status][_eq]=active',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to search psychologists');
    } catch (e) {
      throw Exception('Error searching psychologists: $e');
    }
  }

  // ========== FAQ ==========

  /// Получить все FAQ
  static Future<List<Map<String, dynamic>>> getFAQ({
    String? category,
    String sort = 'order',
  }) async {
    try {
      var url = '$baseUrl/items/faq?filter[status][_eq]=published&sort=$sort';

      if (category != null) {
        url += '&filter[category][_eq]=$category';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to load FAQ');
    } catch (e) {
      throw Exception('Error fetching FAQ: $e');
    }
  }

  // ========== БАННЕРЫ ==========

  /// Получить активные баннеры
  static Future<List<Map<String, dynamic>>> getActiveBanners() async {
    try {
      final now = DateTime.now().toIso8601String();

      final response = await http.get(
        Uri.parse(
          '$baseUrl/items/banners?filter[status][_eq]=active&filter[start_date][_lte]=$now&filter[end_date][_gte]=$now&sort=-priority',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to load banners');
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }

  // ========== УТИЛИТЫ ==========

  /// Получить URL изображения из Directus
  ///
  /// Параметры:
  /// - [fileId]: ID файла из Directus
  /// - [width]: ширина (опционально, для оптимизации)
  /// - [height]: высота (опционально)
  /// - [fit]: режим подгонки (cover, contain, inside, outside)
  /// - [quality]: качество JPEG (1-100)
  static String getImageUrl(
    String fileId, {
    int? width,
    int? height,
    String fit = 'cover',
    int quality = 80,
  }) {
    if (fileId.isEmpty) return '';

    var url = '$baseUrl/assets/$fileId';
    final params = <String>[];

    if (width != null) params.add('width=$width');
    if (height != null) params.add('height=$height');
    params.add('fit=$fit');
    params.add('quality=$quality');

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    return url;
  }

  /// Проверка доступности Directus API
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/server/ping'), headers: _headers)
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
