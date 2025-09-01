import 'package:hive/hive.dart';
import 'cart_model.dart';

part 'cart_item_hive.g.dart';

@HiveType(typeId: 0)
class CartItemHive extends HiveObject {
  @HiveField(0)
  String itemId;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  CartItemHive({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  // Convert from regular CartItem to HiveCartItem
  factory CartItemHive.fromCartItem(CartItem cartItem) {
    return CartItemHive(
      itemId: cartItem.itemId,
      name: cartItem.name,
      price: cartItem.price,
      quantity: cartItem.quantity,
    );
  }

  // Convert to regular CartItem
  CartItem toCartItem() {
    return CartItem(
      itemId: itemId,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
}
