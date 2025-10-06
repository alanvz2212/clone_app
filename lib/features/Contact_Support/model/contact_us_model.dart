class ContactUsRequest {
  final int id;
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String whatsappNumber;
  final String contactNumber;
  final String companyName;
  final String companyAddress;
  final String companyGST;
  final String gstCertificate;

  ContactUsRequest({
    this.id = 0,
    this.referenceId = 0,
    this.referenceType = "string",
    this.companyId = 19,
    this.whatsappNumber = "string",
    this.contactNumber = "string",
    this.companyName = "string",
    this.companyAddress = "string",
    this.companyGST = "string",
    this.gstCertificate = "string",
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'companyId': companyId,
      'whatsappNumber': whatsappNumber,
      'contactNumber': contactNumber,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyGST': companyGST,
      'gstCertificate': gstCertificate,
    };
  }
}

class ContactUsResponse {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic additionalData;

  ContactUsResponse({
    required this.success,
    required this.message,
    this.data,
    this.additionalData,
  });

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      additionalData: json['additionalData'],
    );
  }
}
