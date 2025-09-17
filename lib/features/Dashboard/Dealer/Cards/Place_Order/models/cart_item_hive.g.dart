part of 'cart_item_hive.dart';
class CartItemHiveAdapter extends TypeAdapter<CartItemHive> {
  @override
  final int typeId = 0;
  @override
  CartItemHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemHive(
      itemId: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      quantity: fields[3] as int,
    );
  }
  @override
  void write(BinaryWriter writer, CartItemHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity);
  }
  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

