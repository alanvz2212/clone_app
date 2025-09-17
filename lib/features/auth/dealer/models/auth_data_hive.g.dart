part of 'auth_data_hive.dart';
class AuthDataHiveAdapter extends TypeAdapter<AuthDataHive> {
  @override
  final int typeId = 2;
  @override
  AuthDataHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthDataHive(
      token: fields[0] as String?,
      dealer: fields[1] as DealerHive?,
      isAuthenticated: fields[2] as bool,
      loginTime: fields[3] as DateTime?,
      stayLoggedIn: fields[4] as bool,
      mobileNumber: fields[5] as String?,
      password: fields[6] as String?,
    );
  }
  @override
  void write(BinaryWriter writer, AuthDataHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.dealer)
      ..writeByte(2)
      ..write(obj.isAuthenticated)
      ..writeByte(3)
      ..write(obj.loginTime)
      ..writeByte(4)
      ..write(obj.stayLoggedIn)
      ..writeByte(5)
      ..write(obj.mobileNumber)
      ..writeByte(6)
      ..write(obj.password);
  }
  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthDataHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

