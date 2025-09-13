import 'package:hive/hive.dart';
import 'dealer.dart';

part 'dealer_hive.g.dart';

@HiveType(typeId: 1) // Unique typeId for Dealer model
class DealerHive {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String mobile;

  @HiveField(3)
  final int customerId;

  @HiveField(4)
  final String? contactPerson;

  @HiveField(5)
  final String? contactNumber;

  @HiveField(6)
  final int? stateId;

  @HiveField(7)
  final int? taxID;

  @HiveField(8)
  final int? type;

  @HiveField(9)
  final int? countryId;

  @HiveField(10)
  final int? districtId;

  @HiveField(11)
  final String? notes;

  @HiveField(12)
  final String? numberOfCreditDays;

  @HiveField(13)
  final String? numberOfBlockDays;

  @HiveField(14)
  final int? executiveId;

  @HiveField(15)
  final String? pinCode;

  @HiveField(16)
  final String? bankName;

  @HiveField(17)
  final String? bankBranch;

  @HiveField(18)
  final String? accountNumber;

  @HiveField(19)
  final String? ifscCode;

  @HiveField(20)
  final String? upiId;

  @HiveField(21)
  final String? iban;

  @HiveField(22)
  final String? swiftCode;

  @HiveField(23)
  final int? status;

  @HiveField(24)
  final int? allowEmail;

  @HiveField(25)
  final int? allowTCS;

  @HiveField(26)
  final int? allowSMS;

  @HiveField(27)
  final String? blockReason;

  @HiveField(28)
  final String? creditLimit;

  @HiveField(29)
  final bool? useCostCentre;

  @HiveField(30)
  final String? gstRegistrationType;

  @HiveField(31)
  final String? gstNo;

  @HiveField(32)
  final String? panNo;

  @HiveField(33)
  final String? typeofDuty;

  @HiveField(34)
  final String? gstApplicablility;

  @HiveField(35)
  final String? taxType;

  @HiveField(36)
  final String? hsnCode;

  DealerHive({
    required this.name,
    required this.email,
    required this.mobile,
    required this.customerId,
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

  // Convert from Dealer model to DealerHive
  factory DealerHive.fromDealer(Dealer dealer) {
    return DealerHive(
      name: dealer.name,
      email: dealer.email,
      mobile: dealer.mobile,
      customerId: dealer.customerId,
      contactPerson: dealer.contactPerson,
      contactNumber: dealer.contactNumber,
      stateId: dealer.stateId,
      taxID: dealer.taxID,
      type: dealer.type,
      countryId: dealer.countryId,
      districtId: dealer.districtId,
      notes: dealer.notes,
      numberOfCreditDays: dealer.numberOfCreditDays,
      numberOfBlockDays: dealer.numberOfBlockDays,
      executiveId: dealer.executiveId,
      pinCode: dealer.pinCode,
      bankName: dealer.bankName,
      bankBranch: dealer.bankBranch,
      accountNumber: dealer.accountNumber,
      ifscCode: dealer.ifscCode,
      upiId: dealer.upiId,
      iban: dealer.iban,
      swiftCode: dealer.swiftCode,
      status: dealer.status,
      allowEmail: dealer.allowEmail,
      allowTCS: dealer.allowTCS,
      allowSMS: dealer.allowSMS,
      blockReason: dealer.blockReason,
      creditLimit: dealer.creditLimit,
      useCostCentre: dealer.useCostCentre,
      gstRegistrationType: dealer.gstRegistrationType,
      gstNo: dealer.gstNo,
      panNo: dealer.panNo,
      typeofDuty: dealer.typeofDuty,
      gstApplicablility: dealer.gstApplicablility,
      taxType: dealer.taxType,
      hsnCode: dealer.hsnCode,
    );
  }

  // Convert from DealerHive to Dealer model
  Dealer toDealer() {
    return Dealer(
      name: name,
      email: email,
      mobile: mobile,
      customerId: customerId,
      contactPerson: contactPerson,
      contactNumber: contactNumber,
      stateId: stateId,
      taxID: taxID,
      type: type,
      countryId: countryId,
      districtId: districtId,
      notes: notes,
      numberOfCreditDays: numberOfCreditDays,
      numberOfBlockDays: numberOfBlockDays,
      executiveId: executiveId,
      pinCode: pinCode,
      bankName: bankName,
      bankBranch: bankBranch,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      upiId: upiId,
      iban: iban,
      swiftCode: swiftCode,
      status: status,
      allowEmail: allowEmail,
      allowTCS: allowTCS,
      allowSMS: allowSMS,
      blockReason: blockReason,
      creditLimit: creditLimit,
      useCostCentre: useCostCentre,
      gstRegistrationType: gstRegistrationType,
      gstNo: gstNo,
      panNo: panNo,
      typeofDuty: typeofDuty,
      gstApplicablility: gstApplicablility,
      taxType: taxType,
      hsnCode: hsnCode,
    );
  }
}