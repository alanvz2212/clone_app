import 'package:equatable/equatable.dart';
class Dealer extends Equatable {
  final String name;
  final String email;
  final String mobile;
  final int id;
  final String? contactPerson;
  final String? contactNumber;
  final int? stateId;
  final int? taxID;
  final int? type;
  final int? countryId;
  final int? districtId;
  final String? notes;
  final String? numberOfCreditDays;
  final String? numberOfBlockDays;
  final int? executiveId;
  final String? pinCode;
  final String? bankName;
  final String? bankBranch;
  final String? accountNumber;
  final String? ifscCode;
  final String? upiId;
  final String? iban;
  final String? swiftCode;
  final int? status;
  final int? allowEmail;
  final int? allowTCS;
  final int? allowSMS;
  final String? blockReason;
  final String? creditLimit;
  final bool? useCostCentre;
  final String? gstRegistrationType;
  final String? gstNo;
  final String? panNo;
  final String? typeofDuty;
  final String? gstApplicablility;
  final String? taxType;
  final String? hsnCode;
  const Dealer({
    required this.name,
    required this.email,
    required this.mobile,
    required this.id,
    this.contactPerson,
    this.contactNumber,
    this.stateId,
    this.taxID,
    this.type,
    this.countryId,
    this.districtId,
    this.notes,
    this.numberOfCreditDays,
    this.numberOfBlockDays,
    this.executiveId,
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
    this.useCostCentre,
    this.gstRegistrationType,
    this.gstNo,
    this.panNo,
    this.typeofDuty,
    this.gstApplicablility,
    this.taxType,
    this.hsnCode,
  });
  factory Dealer.fromJson(Map<String, dynamic> json) {
    print('=== Dealer.fromJson Debug ===');
    print('Dealer JSON: $json');
    print('Name field: ${json['name']}');
    print('Email field: ${json['email']}');
    print('Mobile field: ${json['mobile']}');
    print('=== End Dealer Debug ===');
    String name =
        json['name'] as String? ??
        json['dealer_name'] as String? ??
        json['full_name'] as String? ??
        json['username'] as String? ??
        'Unknown Dealer';
    String email =
        json['email'] as String? ??
        json['email_address'] as String? ??
        json['dealer_email'] as String? ??
        '';
    String mobile =
        json['mobile'] as String? ??
        json['mobile_number'] as String? ??
        json['phone'] as String? ??
        json['phone_number'] as String? ??
        '';
    int id =
        json['customerId'] as int? ??
        json['customer_id'] as int? ??
        json['id'] as int? ??
        0;
    return Dealer(
      name: name,
      email: email,
      mobile: mobile,
      id: id,
      contactPerson: json['contactPerson'] as String?,
      contactNumber: json['contactNumber'] as String?,
      stateId: json['stateId'] as int?,
      taxID: json['taxID'] as int?,
      type: json['type'] as int?,
      countryId: json['countryId'] as int?,
      districtId: json['districtId'] as int?,
      notes: json['notes'] as String?,
      numberOfCreditDays: json['numberOfCreditDays'] as String?,
      numberOfBlockDays: json['numberOfBlockDays'] as String?,
      executiveId: json['executiveId'] as int?,
      pinCode: json['pinCode'] as String?,
      bankName: json['bankName'] as String?,
      bankBranch: json['bankBranch'] as String?,
      accountNumber: json['accountNumber'] as String?,
      ifscCode: json['ifscCode'] as String?,
      upiId: json['upiId'] as String?,
      iban: json['iban'] as String?,
      swiftCode: json['swiftCode'] as String?,
      status: json['status'] as int?,
      allowEmail: json['allowEmail'] as int?,
      allowTCS: json['allowTCS'] as int?,
      allowSMS: json['allowSMS'] as int?,
      blockReason: json['blockReason'] as String?,
      creditLimit: json['creditLimit'] as String?,
      useCostCentre: json['useCostCentre'] as bool?,
      gstRegistrationType: json['gstRegistrationType'] as String?,
      gstNo: json['gstNo'] as String?,
      panNo: json['panNo'] as String?,
      typeofDuty: json['typeofDuty'] as String?,
      gstApplicablility: json['gstApplicablility'] as String?,
      taxType: json['taxType'] as String?,
      hsnCode: json['hsnCode'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'customerId': id,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'stateId': stateId,
      'taxID': taxID,
      'type': type,
      'countryId': countryId,
      'districtId': districtId,
      'notes': notes,
      'numberOfCreditDays': numberOfCreditDays,
      'numberOfBlockDays': numberOfBlockDays,
      'executiveId': executiveId,
      'pinCode': pinCode,
      'bankName': bankName,
      'bankBranch': bankBranch,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiId': upiId,
      'iban': iban,
      'swiftCode': swiftCode,
      'status': status,
      'allowEmail': allowEmail,
      'allowTCS': allowTCS,
      'allowSMS': allowSMS,
      'blockReason': blockReason,
      'creditLimit': creditLimit,
      'useCostCentre': useCostCentre,
      'gstRegistrationType': gstRegistrationType,
      'gstNo': gstNo,
      'panNo': panNo,
      'typeofDuty': typeofDuty,
      'gstApplicablility': gstApplicablility,
      'taxType': taxType,
      'hsnCode': hsnCode,
    };
  }
  Dealer copyWith({
    String? name,
    String? email,
    String? mobile,
    int? customerId,
    String? contactPerson,
    String? contactNumber,
    int? stateId,
    int? taxID,
    int? type,
    int? countryId,
    int? districtId,
    String? notes,
    String? numberOfCreditDays,
    String? numberOfBlockDays,
    int? executiveId,
    String? pinCode,
    String? bankName,
    String? bankBranch,
    String? accountNumber,
    String? ifscCode,
    String? upiId,
    String? iban,
    String? swiftCode,
    int? status,
    int? allowEmail,
    int? allowTCS,
    int? allowSMS,
    String? blockReason,
    String? creditLimit,
    bool? useCostCentre,
    String? gstRegistrationType,
    String? gstNo,
    String? panNo,
    String? typeofDuty,
    String? gstApplicablility,
    String? taxType,
    String? hsnCode,
  }) {
    return Dealer(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      id: customerId ?? this.id,
      contactPerson: contactPerson ?? this.contactPerson,
      contactNumber: contactNumber ?? this.contactNumber,
      stateId: stateId ?? this.stateId,
      taxID: taxID ?? this.taxID,
      type: type ?? this.type,
      countryId: countryId ?? this.countryId,
      districtId: districtId ?? this.districtId,
      notes: notes ?? this.notes,
      numberOfCreditDays: numberOfCreditDays ?? this.numberOfCreditDays,
      numberOfBlockDays: numberOfBlockDays ?? this.numberOfBlockDays,
      executiveId: executiveId ?? this.executiveId,
      pinCode: pinCode ?? this.pinCode,
      bankName: bankName ?? this.bankName,
      bankBranch: bankBranch ?? this.bankBranch,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      iban: iban ?? this.iban,
      swiftCode: swiftCode ?? this.swiftCode,
      status: status ?? this.status,
      allowEmail: allowEmail ?? this.allowEmail,
      allowTCS: allowTCS ?? this.allowTCS,
      allowSMS: allowSMS ?? this.allowSMS,
      blockReason: blockReason ?? this.blockReason,
      creditLimit: creditLimit ?? this.creditLimit,
      useCostCentre: useCostCentre ?? this.useCostCentre,
      gstRegistrationType: gstRegistrationType ?? this.gstRegistrationType,
      gstNo: gstNo ?? this.gstNo,
      panNo: panNo ?? this.panNo,
      typeofDuty: typeofDuty ?? this.typeofDuty,
      gstApplicablility: gstApplicablility ?? this.gstApplicablility,
      taxType: taxType ?? this.taxType,
      hsnCode: hsnCode ?? this.hsnCode,
    );
  }
  @override
  List<Object?> get props => [
    name,
    email,
    mobile,
    id,
    contactPerson,
    contactNumber,
    stateId,
    taxID,
    type,
    countryId,
    districtId,
    notes,
    numberOfCreditDays,
    numberOfBlockDays,
    executiveId,
    pinCode,
    bankName,
    bankBranch,
    accountNumber,
    ifscCode,
    upiId,
    iban,
    swiftCode,
    status,
    allowEmail,
    allowTCS,
    allowSMS,
    blockReason,
    creditLimit,
    useCostCentre,
    gstRegistrationType,
    gstNo,
    panNo,
    typeofDuty,
    gstApplicablility,
    taxType,
    hsnCode,
  ];
}

