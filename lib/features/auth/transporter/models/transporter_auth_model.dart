import 'package:equatable/equatable.dart';
import 'transporter.dart';
class TransporterLoginRequest extends Equatable {
  final String mobileNumberOrId;
  final String password;
  const TransporterLoginRequest({
    required this.mobileNumberOrId,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {'mobileNumber': mobileNumberOrId, 'password': password};
  }
  @override
  List<Object?> get props => [mobileNumberOrId, password];
}
class TransporterLoginResponse extends Equatable {
  final bool success;
  final String? token;
  final Transporter? transporter;
  final String? message;
  final String? error;
  const TransporterLoginResponse({
    required this.success,
    this.token,
    this.transporter,
    this.message,
    this.error,
  });
  factory TransporterLoginResponse.fromJson(Map<String, dynamic> json) {
    return TransporterLoginResponse(
      success: json['success'] as bool? ?? false,
      token: json['data'] != null ? json['data']['token'] as String? : null,
      transporter: json['data'] != null && json['data']['data'] != null
          ? Transporter.fromJson(json['data']['data'])
          : null,
      message: json['message'] as String?,
      error: json['success'] == false
          ? json['message'] as String?
          : json['error'] as String?,
    );
  }
  factory TransporterLoginResponse.success({
    required String token,
    required Transporter transporter,
    String? message,
  }) {
    return TransporterLoginResponse(
      success: true,
      token: token,
      transporter: transporter,
      message: message,
    );
  }
  factory TransporterLoginResponse.failure({required String error}) {
    return TransporterLoginResponse(success: false, error: error);
  }
  @override
  List<Object?> get props => [success, token, transporter, message, error];
}
class TransporterForgotPasswordRequest extends Equatable {
  final String mobileNumberOrId;
  const TransporterForgotPasswordRequest({required this.mobileNumberOrId});
  Map<String, dynamic> toJson() {
    return {
      'mobile_number_or_id': mobileNumberOrId,
      'user_type': 'transporter',
    };
  }
  @override
  List<Object?> get props => [mobileNumberOrId];
}

