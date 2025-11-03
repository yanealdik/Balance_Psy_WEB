// lib/models/directus_models.dart

/// Модель статьи из Directus
class DirectusArticle {
  final String id;
  final String status;
  final String title;
  final String slug;
  final String content;
  final String excerpt;
  final String? featuredImage;
  final String category;
  final List<String> tags;
  final String? authorId;
  final int readTime;
  final int views;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DirectusArticle({
    required this.id,
    required this.status,
    required this.title,
    required this.slug,
    required this.content,
    required this.excerpt,
    this.featuredImage,
    required this.category,
    required this.tags,
    this.authorId,
    required this.readTime,
    required this.views,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DirectusArticle.fromJson(Map<String, dynamic> json) {
    return DirectusArticle(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'draft',
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String? ?? '',
      excerpt: json['excerpt'] as String? ?? '',
      featuredImage: json['featured_image'] as String?,
      category: json['category'] as String? ?? 'Общее',
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
      authorId: json['author'] as String?,
      readTime: json['read_time'] as int? ?? 5,
      views: json['views'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'title': title,
      'slug': slug,
      'content': content,
      'excerpt': excerpt,
      'featured_image': featuredImage,
      'category': category,
      'tags': tags,
      'author': authorId,
      'read_time': readTime,
      'views': views,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Модель психолога из Directus
class DirectusPsychologist {
  final String id;
  final String status;
  final String fullName;
  final String slug;
  final String? avatar;
  final List<String> specializations;
  final int experienceYears;
  final double rating;
  final int price;
  final String description;
  final List<Map<String, dynamic>> education;
  final List<String> languages;
  final Map<String, dynamic>? availableTimes;
  final DateTime createdAt;
  final DateTime updatedAt;

  DirectusPsychologist({
    required this.id,
    required this.status,
    required this.fullName,
    required this.slug,
    this.avatar,
    required this.specializations,
    required this.experienceYears,
    required this.rating,
    required this.price,
    required this.description,
    required this.education,
    required this.languages,
    this.availableTimes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DirectusPsychologist.fromJson(Map<String, dynamic> json) {
    return DirectusPsychologist(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'inactive',
      fullName: json['full_name'] as String,
      slug: json['slug'] as String,
      avatar: json['avatar'] as String?,
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'] as List)
          : [],
      experienceYears: json['experience_years'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: json['price'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      education: json['education'] != null
          ? List<Map<String, dynamic>>.from(json['education'] as List)
          : [],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'] as List)
          : ['Русский'],
      availableTimes: json['available_times'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'full_name': fullName,
      'slug': slug,
      'avatar': avatar,
      'specializations': specializations,
      'experience_years': experienceYears,
      'rating': rating,
      'price': price,
      'description': description,
      'education': education,
      'languages': languages,
      'available_times': availableTimes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Модель FAQ из Directus
class DirectusFAQ {
  final String id;
  final String status;
  final String question;
  final String answer;
  final String category;
  final int order;
  final DateTime createdAt;

  DirectusFAQ({
    required this.id,
    required this.status,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
    required this.createdAt,
  });

  factory DirectusFAQ.fromJson(Map<String, dynamic> json) {
    return DirectusFAQ(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'draft',
      question: json['question'] as String,
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? 'Общие',
      order: json['order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Модель баннера из Directus
class DirectusBanner {
  final String id;
  final String status;
  final String title;
  final String description;
  final String? image;
  final String? link;
  final DateTime startDate;
  final DateTime endDate;
  final int priority;

  DirectusBanner({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    this.image,
    this.link,
    required this.startDate,
    required this.endDate,
    required this.priority,
  });

  factory DirectusBanner.fromJson(Map<String, dynamic> json) {
    return DirectusBanner(
      id: json['id'] as String,
      status: json['status'] as String? ?? 'inactive',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
      link: json['link'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      priority: json['priority'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'title': title,
      'description': description,
      'image': image,
      'link': link,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'priority': priority,
    };
  }

  /// Проверить, активен ли баннер сейчас
  bool get isActive {
    final now = DateTime.now();
    return status == 'active' &&
        now.isAfter(startDate) &&
        now.isBefore(endDate);
  }
}
