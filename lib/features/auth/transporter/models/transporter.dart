import 'package:equatable/equatable.dart';

class Transporter extends Equatable {
  final String id;
  final String mobileNumber;
  final String transporterId;
  final String name;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const Transporter({
    required this.id,
    required this.mobileNumber,
    required this.transporterId,
    required this.name,
    required this.email,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory Transporter.fromJson(Map<String, dynamic> json) {
    return Transporter(
      id: json['id'] as String,
      mobileNumber: json['mobile_number'] as String,
      transporterId: json['transporter_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile_number': mobileNumber,
      'transporter_id': transporterId,
      'name': name,
      'email': email,
      'user_type': 'transporter',
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  Transporter copyWith({
    String? id,
    String? mobileNumber,
    String? transporterId,
    String? name,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return Transporter(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      transporterId: transporterId ?? this.transporterId,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    mobileNumber,
    transporterId,
    name,
    email,
    isActive,
    createdAt,
    lastLoginAt,
  ];
}
