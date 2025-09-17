class OtpResponseModel {
  final bool success;
  final String message;
  OtpResponseModel({
    required this.success,
    required this.message,
  });
  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}

