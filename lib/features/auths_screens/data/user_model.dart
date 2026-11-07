class UserModel {
    String? id;
  final String fullName;
  final String email;
  final DateTime createdAt;
  final String password;
  UserModel({
      this.id,
    required this.fullName,
    required this.email,
    required  this.password,
    required this.createdAt,
  });

  /// Convert JSON to Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// CopyWith
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}