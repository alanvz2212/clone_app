class FeedbackRequest {
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String name;
  final int customerId;
  final String email;
  final String customerFeedBack;
  final int rating;

  FeedbackRequest({
    required this.referenceId,
    required this.referenceType,
    required this.companyId,
    required this.name,
    required this.customerId,
    required this.email,
    required this.customerFeedBack,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'referenceId': referenceId,
      'referenceType': referenceType,
      'companyId': companyId,
      'name': name,
      'customerId': customerId,
      'email': email,
      'customerFeedBack': customerFeedBack,
      'rating': rating,
    };
  }
}

class FeedbackResponse {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic additionalData;

  FeedbackResponse({
    required this.success,
    required this.message,
    this.data,
    this.additionalData,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      additionalData: json['additionalData'],
    );
  }
}