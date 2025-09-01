import 'package:hive/hive.dart';
import '../models/cart_model.dart';
import '../models/cart_item_hive.dart';

class CartHiveService {
  static const String _cartBoxName = 'cart_box';
  static Box<CartItemHive>? _cartBox;

  // Initialize Hive box
  static Future<void> init() async {
    _cartBox = await Hive.openBox<CartItemHive>(_cartBoxName);
  }

  // Get the cart box
  static Box<CartItemHive> get cartBox {
    if (_cartBox == null || !_cartBox!.isOpen) {
      throw Exception(
        'Cart box is not initialized. Call CartHiveService.init() first.',
      );
    }
    return _cartBox!;
  }

  // Save cart item to Hive
  static Future<void> saveCartItem(CartItem cartItem) async {
    final hiveItem = CartItemHive.fromCartItem(cartItem);
    await cartBox.put(cartItem.itemId, hiveItem);
  }

  // Get all cart items from Hive
  static List<CartItem> getAllCartItems() {
    return cartBox.values.map((hiveItem) => hiveItem.toCartItem()).toList();
  }

  // Get specific cart item by ID
  static CartItem? getCartItem(String itemId) {
    final hiveItem = cartBox.get(itemId);
    return hiveItem?.toCartItem();
  }

  // Update cart item quantity
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

  // Remove cart item from Hive
  static Future<void> removeCartItem(String itemId) async {
    await cartBox.delete(itemId);
  }

  // Clear all cart items
  static Future<void> clearCart() async {
    await cartBox.clear();
  }

  // Check if cart is empty
  static bool isCartEmpty() {
    return cartBox.isEmpty;
  }

  // Get total items count
  static int getTotalItems() {
    return cartBox.values.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get total amount
  static double getTotalAmount() {
    return cartBox.values.fold(0.0, (sum, item) => sum + item.total);
  }

  // Close the box (call this when app is closing)
  static Future<void> close() async {
    await _cartBox?.close();
  }

  // NEW: Save entire cart to Hive
  static Future<void> saveCart(Cart cart) async {
    // First clear existing items
    await clearCart();

    // Save all items from the cart
    for (final item in cart.items) {
      await saveCartItem(item);
    }
  }

  // NEW: Load entire cart from Hive
  static Cart loadCart() {
    final cartItems = getAllCartItems();
    final cart = Cart();

    // Add all items to the cart
    for (final item in cartItems) {
      cart.addItem(item.itemId, item.name, item.price, item.quantity);
    }

    return cart;
  }
}
