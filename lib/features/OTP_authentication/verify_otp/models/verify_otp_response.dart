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
    print('=== VerifyOtpResponse.fromJson Debug ===');
    print('JSON: $json');
    try {
      return VerifyOtpResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? VerifyOtpData.fromJson(json['data']) : null,
        additionalData: json['additionalData'],
      );
    } catch (e) {
      print('Error in VerifyOtpResponse.fromJson: $e');
      rethrow;
    }
  }
}
class VerifyOtpData {
  final List<dynamic> mobileUser;
  final String phoneNumber;
  final UserData data;
  final String token;
  final String refresh;
  VerifyOtpData({
    required this.mobileUser,
    required this.phoneNumber,
    required this.data,
    required this.token,
    required this.refresh,
  });
  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    print('=== VerifyOtpData.fromJson Debug ===');
    print('JSON: $json');
    try {
      return VerifyOtpData(
        mobileUser: json['mobileUser'] ?? [],
        phoneNumber: json['phoneNumber'] ?? '',
        data: UserData.fromJson(json['data']),
        token: json['token'] ?? '',
        refresh: json['refresh'] ?? '',
      );
    } catch (e) {
      print('Error in VerifyOtpData.fromJson: $e');
      rethrow;
    }
  }
}
class UserData {
  final String name;
  final String email;
  final String password;
  final String mobile;
  final String whatsappNumber;
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
  final bool isSpecifier;
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
    required this.whatsappNumber,
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
    required this.isSpecifier,
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
    print('=== UserData.fromJson Debug ===');
    print('JSON: $json');
    print('stateId type: ${json['stateId'].runtimeType}, value: ${json['stateId']}');
    print('type type: ${json['type'].runtimeType}, value: ${json['type']}');
    print('countryId type: ${json['countryId'].runtimeType}, value: ${json['countryId']}');
    print('districtId type: ${json['districtId'].runtimeType}, value: ${json['districtId']}');
    print('numberOfCreditDays type: ${json['numberOfCreditDays'].runtimeType}, value: ${json['numberOfCreditDays']}');
    print('numberOfBlockDays type: ${json['numberOfBlockDays'].runtimeType}, value: ${json['numberOfBlockDays']}');
    print('executiveId type: ${json['executiveId'].runtimeType}, value: ${json['executiveId']}');
    print('referenceId type: ${json['referenceId'].runtimeType}, value: ${json['referenceId']}');
    print('id type: ${json['id'].runtimeType}, value: ${json['id']}');
    try {
      return UserData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      salt: json['salt'] ?? '',
      contactPerson: json['contactPerson'],
      contactNumber: json['contactNumber'],
      stateId: json['stateId'] is String 
          ? int.tryParse(json['stateId'] as String)
          : json['stateId'] as int?,
      state: json['state'],
      taxID: json['taxID']?.toString(),
      type: json['type'] is String 
          ? int.tryParse(json['type'] as String) ?? 0
          : json['type'] as int? ?? 0,
      countryId: json['countryId'] is String 
          ? int.tryParse(json['countryId'] as String)
          : json['countryId'] as int?,
      country: json['country'],
      districtId: json['districtId'] is String 
          ? int.tryParse(json['districtId'] as String)
          : json['districtId'] as int?,
      district: json['district'],
      notes: json['notes']?.toString(),
      numberOfCreditDays: json['numberOfCreditDays'] is String 
          ? int.tryParse(json['numberOfCreditDays'] as String)
          : json['numberOfCreditDays'] as int?,
      numberOfBlockDays: json['numberOfBlockDays'] is String 
          ? int.tryParse(json['numberOfBlockDays'] as String)
          : json['numberOfBlockDays'] as int?,
      executiveId: json['executiveId'] is String 
          ? int.tryParse(json['executiveId'] as String)
          : json['executiveId'] as int?,
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
      isSpecifier: json['isSpecifier'] ?? false,
      address: json['address'],
      branchId: json['branchId'] is String 
          ? int.tryParse(json['branchId'] as String)
          : json['branchId'] as int?,
      branch: json['branch'],
      referenceId: json['referenceId'] is String 
          ? int.tryParse(json['referenceId'] as String) ?? 0
          : json['referenceId'] as int? ?? 0,
      referenceType: json['referenceType']?.toString() ?? '',
      companyId: json['companyId'] is String 
          ? int.tryParse(json['companyId'] as String)
          : json['companyId'] as int?,
      company: json['company'],
      id: json['id'] is String 
          ? int.tryParse(json['id'] as String) ?? 0
          : json['id'] as int? ?? 0,
      mainId: json['mainId']?.toString() ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'] ?? '',
      createdBy: json['createdBy'],
    );
    } catch (e) {
      print('Error in UserData.fromJson: $e');
      rethrow;
    }
  }
}

