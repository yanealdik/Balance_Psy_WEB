/// Модель данных для регистрации пользователя
/// Готова к сериализации для отправки на REST API
class UserRegisterModel {
  String? name;
  String? email;
  String? password;
  DateTime? birthDate;
  String? gender;
  List<String> purposes = [];
  List<String> interests = [];
  String? verificationCode;
  bool isMinor = false;
  String? parentEmail;

  UserRegisterModel({
    this.name,
    this.email,
    this.password,
    this.birthDate,
    this.gender,
    List<String>? purposes,
    List<String>? interests,
    this.verificationCode,
    this.isMinor = false,
    this.parentEmail,
  }) {
    this.purposes = purposes ?? [];
    this.interests = interests ?? [];
  }

  /// Преобразование в JSON для отправки на backend
  /// POST /api/auth/register
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'purposes': purposes,
      'interests': interests,
      'isMinor': isMinor,
      'parentEmail': parentEmail,
    };
  }

  /// Создание модели из JSON (для тестирования или восстановления данных)
  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      gender: json['gender'],
      purposes: List<String>.from(json['purposes'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      isMinor: json['isMinor'] ?? false,
      parentEmail: json['parentEmail'],
    );
  }

  /// Валидация данных перед отправкой
  bool isValid() {
    if (name == null || name!.isEmpty) return false;
    if (email == null || !_isValidEmail(email!)) return false;
    if (password == null || password!.length < 6) return false;
    if (birthDate == null) return false;
    if (gender == null || gender!.isEmpty) return false;
    if (purposes.isEmpty) return false;

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Проверка возраста
  int? getAge() {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}
