// lib/models/user_model.dart

class UserModel {
  final int userId;
  final String email;
  final String fullName;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? avatarUrl;
  final String role;
  final bool isActive;
  final bool emailVerified;
  final String? parentEmail;
  final bool? parentEmailVerified;
  final String? gender;
  final List<String> interests;
  final String? registrationGoal;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLogin;

  UserModel({
    required this.userId,
    required this.email,
    required this.fullName,
    this.phone,
    this.dateOfBirth,
    this.avatarUrl,
    required this.role,
    required this.isActive,
    required this.emailVerified,
    this.parentEmail,
    this.parentEmailVerified,
    this.gender,
    required this.interests,
    this.registrationGoal,
    required this.createdAt,
    this.updatedAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String,
      isActive: json['isActive'] as bool? ?? true,
      emailVerified: json['emailVerified'] as bool? ?? false,
      parentEmail: json['parentEmail'] as String?,
      parentEmailVerified: json['parentEmailVerified'] as bool?,
      gender: json['gender'] as String?,
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      registrationGoal: json['registrationGoal'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'role': role,
      'isActive': isActive,
      'emailVerified': emailVerified,
      'parentEmail': parentEmail,
      'parentEmailVerified': parentEmailVerified,
      'gender': gender,
      'interests': interests,
      'registrationGoal': registrationGoal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? userId,
    String? email,
    String? fullName,
    String? phone,
    DateTime? dateOfBirth,
    String? avatarUrl,
    String? role,
    bool? isActive,
    bool? emailVerified,
    String? parentEmail,
    bool? parentEmailVerified,
    String? gender,
    List<String>? interests,
    String? registrationGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      parentEmail: parentEmail ?? this.parentEmail,
      parentEmailVerified: parentEmailVerified ?? this.parentEmailVerified,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      registrationGoal: registrationGoal ?? this.registrationGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  String get displayName => fullName;

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  bool get isMinor => age != null && age! < 18;
}
