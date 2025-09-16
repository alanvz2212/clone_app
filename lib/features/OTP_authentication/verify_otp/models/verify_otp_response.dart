class VerifyOtpResponse {
  final bool success;
  final String message;
  final VerifyOtpData? data;
  final dynamic additionalData;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    this.data,
    this.additionalData,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
      additionalData: json['additionalData'],
    );
  }
}

class VerifyOtpData {
  final UserData data;
  final String token;
  final String refresh;

  VerifyOtpData({
    required this.data,
    required this.token,
    required this.refresh,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      data: UserData.fromJson(json['data']),
      token: json['token'] ?? '',
      refresh: json['refresh'] ?? '',
    );
  }
}

class UserData {
  final String name;
  final String email;
  final String mobile;
  final String? contactPerson;
  final String? contactNumber;
  final int? stateId;
  final int type;
  final int? countryId;
  final int? districtId;
  final String? pinCode;
  final int? executiveId;
  final String? gstNo;
  final String? panNo;
  final int? companyId;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;

  UserData({
    required this.name,
    required this.email,
    required this.mobile,
    this.contactPerson,
    this.contactNumber,
    this.stateId,
    required this.type,
    this.countryId,
    this.districtId,
    this.pinCode,
    this.executiveId,
    this.gstNo,
    this.panNo,
    this.companyId,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      contactPerson: json['contactPerson'],
      contactNumber: json['contactNumber'],
      stateId: json['stateId'],
      type: json['type'] ?? 0,
      countryId: json['countryId'],
      districtId: json['districtId'],
      pinCode: json['pinCode'],
      executiveId: json['executiveId'],
      gstNo: json['gstNo'],
      panNo: json['panNo'],
      companyId: json['companyId'],
      id: json['id'] ?? 0,
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
    );
  }
}