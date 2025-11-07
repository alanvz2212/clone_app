enum UserType { dealer, transporter }
class User {
  final String userId;
  final String mobileNumber;
  final String name;
  final String email;
  final UserType userType;
  final int id;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isSpecifier;
  const User({
    required this.userId,
    required this.mobileNumber,
    required this.name,
    required this.email,
    required this.userType,
    required this.id,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
    this.isSpecifier = false,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: UserType.values.firstWhere(
        (type) => type.name == json['user_type'],
        orElse: () => UserType.dealer,
      ),
      id: json['customer_id'] as int? ?? json['customerId'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      isSpecifier: json['is_specifier'] as bool? ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'mobile_number': mobileNumber,
      'name': name,
      'email': email,
      'user_type': userType.name,
      'customer_id': id,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'is_specifier': isSpecifier,
    };
  }
}

