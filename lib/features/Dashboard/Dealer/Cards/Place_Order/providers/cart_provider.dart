import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../services/cart_hive_service.dart';

class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();

  // Initialize cart provider and load data from Hive
  CartProvider() {
    _loadCartFromHive();
  }

  Cart get cart => _cart;

  List<CartItem> get items => _cart.items;

  int get totalItems => _cart.totalItems;

  double get totalAmount => _cart.totalAmount;

  bool get isEmpty => _cart.isEmpty();

  // Load cart items from Hive storage
  void _loadCartFromHive() {
    try {
      final savedItems = CartHiveService.getAllCartItems();
      _cart.clear();
      for (final item in savedItems) {
        _cart.addItem(item.itemId, item.name, item.price, item.quantity);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart from Hive: $e');
    }
  }

  // Add item to cart and save to Hive
  Future<void> addItem(
    String itemId,
    String name,
    double price,
    int quantity,
  ) async {
    _cart.addItem(itemId, name, price, quantity);

    // Save to Hive
    try {
      final cartItem = CartItem(
        itemId: itemId,
        name: name,
        price: price,
        quantity: quantity,
      );
      await CartHiveService.saveCartItem(cartItem);
    } catch (e) {
      debugPrint('Error saving item to Hive: $e');
    }

    notifyListeners();
  }

  // Remove item from cart and Hive
  Future<void> removeItem(String itemId) async {
    _cart.removeItem(itemId);

    // Remove from Hive
    try {
      await CartHiveService.removeCartItem(itemId);
    } catch (e) {
      debugPrint('Error removing item from Hive: $e');
    }

    notifyListeners();
  }

  // Update quantity in cart and Hive
  Future<void> updateQuantity(String itemId, int quantity) async {
    _cart.updateQuantity(itemId, quantity);

    // Update in Hive
    try {
      await CartHiveService.updateCartItemQuantity(itemId, quantity);
    } catch (e) {
      debugPrint('Error updating quantity in Hive: $e');
    }

    notifyListeners();
  }

  // Clear cart and Hive storage
  Future<void> clearCart() async {
    _cart.clear();

    // Clear Hive storage
    try {
      await CartHiveService.clearCart();
    } catch (e) {
      debugPrint('Error clearing cart in Hive: $e');
    }

    notifyListeners();
  }

  CartItem? getItem(String itemId) {
    try {
      return _cart.items.firstWhere((item) => item.itemId == itemId);
    } catch (e) {
      return null;
    }
  }

  // Refresh cart from Hive (useful when app resumes)
  void refreshFromHive() {
    _loadCartFromHive();
  }
}
