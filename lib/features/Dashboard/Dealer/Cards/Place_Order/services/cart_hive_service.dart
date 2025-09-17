import 'package:hive/hive.dart';
import '../models/cart_model.dart';
import '../models/cart_item_hive.dart';
class CartHiveService {
  static const String _cartBoxName = 'cart_box';
  static Box<CartItemHive>? _cartBox;
  static Future<void> init() async {
    _cartBox = await Hive.openBox<CartItemHive>(_cartBoxName);
  }
  static Box<CartItemHive> get cartBox {
    if (_cartBox == null || !_cartBox!.isOpen) {
      throw Exception(
        'Cart box is not initialized. Call CartHiveService.init() first.',
      );
    }
    return _cartBox!;
  }
  static Future<void> saveCartItem(CartItem cartItem) async {
    final hiveItem = CartItemHive.fromCartItem(cartItem);
    await cartBox.put(cartItem.itemId, hiveItem);
  }
  static List<CartItem> getAllCartItems() {
    return cartBox.values.map((hiveItem) => hiveItem.toCartItem()).toList();
  }
  static CartItem? getCartItem(String itemId) {
    final hiveItem = cartBox.get(itemId);
    return hiveItem?.toCartItem();
  }
  static Future<void> updateCartItemQuantity(
    String itemId,
    int quantity,
  ) async {
    final hiveItem = cartBox.get(itemId);
    if (hiveItem != null) {
      if (quantity <= 0) {
        await removeCartItem(itemId);
      } else {
        hiveItem.quantity = quantity;
        await cartBox.put(itemId, hiveItem);
      }
    }
  }
  static Future<void> removeCartItem(String itemId) async {
    await cartBox.delete(itemId);
  }
  static Future<void> clearCart() async {
    await cartBox.clear();
  }
  static bool isCartEmpty() {
    return cartBox.isEmpty;
  }
  static int getTotalItems() {
    return cartBox.values.fold(0, (sum, item) => sum + item.quantity);
  }
  static double getTotalAmount() {
    return cartBox.values.fold(0.0, (sum, item) => sum + item.total);
  }
  static Future<void> close() async {
    await _cartBox?.close();
  }
  static Future<void> saveCart(Cart cart) async {
    await clearCart();
    for (final item in cart.items) {
      await saveCartItem(item);
    }
  }
  static Cart loadCart() {
    final cartItems = getAllCartItems();
    final cart = Cart();
    for (final item in cartItems) {
      cart.addItem(item.itemId, item.name, item.price, item.quantity);
    }
    return cart;
  }
}

