import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/models/cart_model.dart';
import 'package:hive/hive.dart';

part 'cart_item_hive.g.dart'; // This will be generated

@HiveType(typeId: 0) // Unique typeId for each model
class CartItemHive {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  int quantity;

  CartItemHive({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  // Convert to your original CartItem model
  CartItem toCartItem() {
    return CartItem(
      itemId: itemId,
      name: name,
      price: price,
      quantity: quantity,
    );
  }

  // Convert from your original CartItem model
  factory CartItemHive.fromCartItem(CartItem item) {
    return CartItemHive(
      itemId: item.itemId,
      name: item.name,
      price: item.price,
      quantity: item.quantity,
    );
  }
}
