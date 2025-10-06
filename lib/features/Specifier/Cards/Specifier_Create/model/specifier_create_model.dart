class SpecifierCreateRequest {
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String projectNames;
  final String contactPerson;
  final String contactNumber;
  final String remarks;
  final String sheet;
  final int specifierId;

  SpecifierCreateRequest({
    this.referenceId = 0,
    this.referenceType = "string",
    this.companyId = 19,
    required String projectName,
    required this.contactPerson,
    required this.contactNumber,
    required this.remarks,
    required this.sheet,
    this.specifierId = 38613,
  }) : projectNames = projectName;
  
  Map<String, dynamic> toJson() {
    return {
      'referenceId': referenceId,
      'referenceType': referenceType,
      'companyId': companyId,
      'projectNames': projectNames,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'remarks': remarks,
      'sheet': sheet,
      'specifierId': specifierId,
    };
  }
}

class SpecifierCreateResponse {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic additionalData;

  SpecifierCreateResponse({
    required this.success,
    required this.message,
    this.data,
    this.additionalData,
  });
  factory SpecifierCreateResponse.fromJson(Map<String, dynamic> json) {
    return SpecifierCreateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      additionalData: json['additionalData'],
    );
  }
}
