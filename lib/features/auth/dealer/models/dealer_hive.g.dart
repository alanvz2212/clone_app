part of 'dealer_hive.dart';
class DealerHiveAdapter extends TypeAdapter<DealerHive> {
  @override
  final int typeId = 1;
  @override
  DealerHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealerHive(
      name: fields[0] as String,
      email: fields[1] as String,
      mobile: fields[2] as String,
      id: fields[3] as int,
      contactPerson: fields[4] as String?,
      contactNumber: fields[5] as String?,
      stateId: fields[6] as int?,
      taxID: fields[7] as int?,
      type: fields[8] as int?,
      countryId: fields[9] as int?,
      districtId: fields[10] as int?,
      notes: fields[11] as String?,
      numberOfCreditDays: fields[12] as String?,
      numberOfBlockDays: fields[13] as String?,
      executiveId: fields[14] as int?,
      pinCode: fields[15] as String?,
      bankName: fields[16] as String?,
      bankBranch: fields[17] as String?,
      accountNumber: fields[18] as String?,
      ifscCode: fields[19] as String?,
      upiId: fields[20] as String?,
      iban: fields[21] as String?,
      swiftCode: fields[22] as String?,
      status: fields[23] as int?,
      allowEmail: fields[24] as int?,
      allowTCS: fields[25] as int?,
      allowSMS: fields[26] as int?,
      blockReason: fields[27] as String?,
      creditLimit: fields[28] as String?,
      useCostCentre: fields[29] as bool?,
      gstRegistrationType: fields[30] as String?,
      gstNo: fields[31] as String?,
      panNo: fields[32] as String?,
      typeofDuty: fields[33] as String?,
      gstApplicablility: fields[34] as String?,
      taxType: fields[35] as String?,
      hsnCode: fields[36] as String?,
    );
  }
  @override
  void write(BinaryWriter writer, DealerHive obj) {
    writer
      ..writeByte(37)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.contactPerson)
      ..writeByte(5)
      ..write(obj.contactNumber)
      ..writeByte(6)
      ..write(obj.stateId)
      ..writeByte(7)
      ..write(obj.taxID)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.countryId)
      ..writeByte(10)
      ..write(obj.districtId)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.numberOfCreditDays)
      ..writeByte(13)
      ..write(obj.numberOfBlockDays)
      ..writeByte(14)
      ..write(obj.executiveId)
      ..writeByte(15)
      ..write(obj.pinCode)
      ..writeByte(16)
      ..write(obj.bankName)
      ..writeByte(17)
      ..write(obj.bankBranch)
      ..writeByte(18)
      ..write(obj.accountNumber)
      ..writeByte(19)
      ..write(obj.ifscCode)
      ..writeByte(20)
      ..write(obj.upiId)
      ..writeByte(21)
      ..write(obj.iban)
      ..writeByte(22)
      ..write(obj.swiftCode)
      ..writeByte(23)
      ..write(obj.status)
      ..writeByte(24)
      ..write(obj.allowEmail)
      ..writeByte(25)
      ..write(obj.allowTCS)
      ..writeByte(26)
      ..write(obj.allowSMS)
      ..writeByte(27)
      ..write(obj.blockReason)
      ..writeByte(28)
      ..write(obj.creditLimit)
      ..writeByte(29)
      ..write(obj.useCostCentre)
      ..writeByte(30)
      ..write(obj.gstRegistrationType)
      ..writeByte(31)
      ..write(obj.gstNo)
      ..writeByte(32)
      ..write(obj.panNo)
      ..writeByte(33)
      ..write(obj.typeofDuty)
      ..writeByte(34)
      ..write(obj.gstApplicablility)
      ..writeByte(35)
      ..write(obj.taxType)
      ..writeByte(36)
      ..write(obj.hsnCode);
  }
  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealerHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

