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
  final String password;
  final String mobile;
  final String salt;
  final String? contactPerson;
  final String? contactNumber;
  final int? stateId;
  final dynamic state;
  final String? taxID;
  final int type;
  final int? countryId;
  final dynamic country;
  final int? districtId;
  final dynamic district;
  final String? notes;
  final int? numberOfCreditDays;
  final int? numberOfBlockDays;
  final int? executiveId;
  final dynamic employee;
  final String? pinCode;
  final String? bankName;
  final String? bankBranch;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? iban;
  final String? swiftCode;
  final dynamic status;
  final bool? allowEmail;
  final bool? allowTCS;
  final bool? allowSMS;
  final String? blockReason;
  final double? creditLimit;
  final bool useCostCentre;
  final String? gstRegistrationType;
  final String? gstNo;
  final String? panNo;
  final String? typeofDuty;
  final String? gstApplicablility;
  final String? taxType;
  final String? hsnCode;
  final double? taxRate;
  final bool maintainBill;
  final bool isTaxApplicable;
  final String? address;
  final int? branchId;
  final dynamic branch;
  final int referenceId;
  final String referenceType;
  final int? companyId;
  final dynamic company;
  final int id;
  final String mainId;
  final bool isDeleted;
  final String createdDate;
  final String updatedDate;
  final dynamic createdBy;
  UserData({
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.salt,
    this.contactPerson,
    this.contactNumber,
    this.stateId,
    this.state,
    this.taxID,
    required this.type,
    this.countryId,
    this.country,
    this.districtId,
    this.district,
    this.notes,
    this.numberOfCreditDays,
    this.numberOfBlockDays,
    this.executiveId,
    this.employee,
    this.pinCode,
    this.bankName,
    this.bankBranch,
    this.accountNumber,
    this.ifscCode,
    this.upiId,
    this.iban,
    this.swiftCode,
    this.status,
    this.allowEmail,
    this.allowTCS,
    this.allowSMS,
    this.blockReason,
    this.creditLimit,
    required this.useCostCentre,
    this.gstRegistrationType,
    this.gstNo,
    this.panNo,
    this.typeofDuty,
    this.gstApplicablility,
    this.taxType,
    this.hsnCode,
    this.taxRate,
    required this.maintainBill,
    required this.isTaxApplicable,
    this.address,
    this.branchId,
    this.branch,
    required this.referenceId,
    required this.referenceType,
    this.companyId,
    this.company,
    required this.id,
    required this.mainId,
    required this.isDeleted,
    required this.createdDate,
    required this.updatedDate,
    this.createdBy,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      salt: json['salt'] ?? '',
      contactPerson: json['contactPerson'],
      contactNumber: json['contactNumber'],
      stateId: json['stateId'],
      state: json['state'],
      taxID: json['taxID'],
      type: json['type'] ?? 0,
      countryId: json['countryId'],
      country: json['country'],
      districtId: json['districtId'],
      district: json['district'],
      notes: json['notes'],
      numberOfCreditDays: json['numberOfCreditDays'],
      numberOfBlockDays: json['numberOfBlockDays'],
      executiveId: json['executiveId'],
      employee: json['employee'],
      pinCode: json['pinCode'],
      bankName: json['bankName'],
      bankBranch: json['bankBranch'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
      upiId: json['upiId'],
      iban: json['iban'],
      swiftCode: json['swiftCode'],
      status: json['status'],
      allowEmail: json['allowEmail'],
      allowTCS: json['allowTCS'],
      allowSMS: json['allowSMS'],
      blockReason: json['blockReason'],
      creditLimit: json['creditLimit']?.toDouble(),
      useCostCentre: json['useCostCentre'] ?? false,
      gstRegistrationType: json['gstRegistrationType'],
      gstNo: json['gstNo'],
      panNo: json['panNo'],
      typeofDuty: json['typeofDuty'],
      gstApplicablility: json['gstApplicablility'],
      taxType: json['taxType'],
      hsnCode: json['hsnCode'],
      taxRate: json['taxRate']?.toDouble(),
      maintainBill: json['maintainBill'] ?? false,
      isTaxApplicable: json['isTaxApplicable'] ?? false,
      address: json['address'],
      branchId: json['branchId'],
      branch: json['branch'],
      referenceId: json['referenceId'] ?? 0,
      referenceType: json['referenceType'] ?? '',
      companyId: json['companyId'],
      company: json['company'],
      id: json['id'] ?? 0,
      mainId: json['mainId'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
  }
}

