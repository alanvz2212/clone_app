import 'package:equatable/equatable.dart';
import 'user.dart';
class LoginRequest extends Equatable {
  final String mobileNumberOrId;
  final String password;
  final UserType userType;
  const LoginRequest({
    required this.mobileNumberOrId,
    required this.password,
    required this.userType,
  });
  Map<String, dynamic> toJson() {
    return {
      'mobile_number_or_id': mobileNumberOrId,
      'password': password,
      'user_type': userType.name,
    };
  }
  @override
  List<Object?> get props => [mobileNumberOrId, password, userType];
}
class LoginResponse extends Equatable {
  final bool success;
  final String? token;
  final User? user;
  final String? message;
  final String? error;
  const LoginResponse({
    required this.success,
    this.token,
    this.user,
    this.message,
    this.error,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      token: json['token'] as String?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
  factory LoginResponse.success({
    required String token,
    required User user,
    String? message,
  }) {
    return LoginResponse(
      success: true,
      token: token,
      user: user,
      message: message,
    );
  }
  factory LoginResponse.failure({required String error}) {
    return LoginResponse(success: false, error: error);
  }
  @override
  List<Object?> get props => [success, token, user, message, error];
}
class ForgotPasswordRequest extends Equatable {
  final String mobileNumberOrId;
  final UserType userType;
  const ForgotPasswordRequest({
    required this.mobileNumberOrId,
    required this.userType,
  });
  Map<String, dynamic> toJson() {
    return {
      'mobile_number_or_id': mobileNumberOrId,
      'user_type': userType.name,
    };
  }
  @override
  List<Object?> get props => [mobileNumberOrId, userType];
}

