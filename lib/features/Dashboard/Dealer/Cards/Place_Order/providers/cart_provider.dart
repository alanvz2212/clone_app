import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../Services/cart_hive_service.dart';
class CartProvider with ChangeNotifier {
  Cart _cart = Cart();
  Cart get cart => _cart;
  List<CartItem> get items => _cart.items;
  int get totalItems => _cart.totalItems;
  double get totalAmount => _cart.totalAmount;
  bool get isEmpty => _cart.isEmpty();
  CartProvider() {
    _loadCartFromHive();
  }
  Future<void> _loadCartFromHive() async {
    try {
      _cart = CartHiveService.loadCart();
    } catch (e) {
      _cart = Cart();
    }
    notifyListeners();
  }
  Future<void> addItem(
    String itemId,
    String name,
    double price,
    int quantity,
  ) async {
    _cart.addItem(itemId, name, price, quantity);
    await CartHiveService.saveCart(_cart);
    notifyListeners();
  }
  Future<void> updateQuantity(String itemId, int quantity) async {
    _cart.updateQuantity(itemId, quantity);
    await CartHiveService.saveCart(_cart);
    notifyListeners();
  }
  Future<void> removeItem(String itemId) async {
    _cart.removeItem(itemId);
    await CartHiveService.saveCart(_cart);
    notifyListeners();
  }
  Future<void> clearCart() async {
    _cart.clear();
    await CartHiveService.clearCart();
    notifyListeners();
  }
  int getItemQuantity(String itemId) {
    final item = _cart.items.firstWhere(
      (item) => item.itemId == itemId,
      orElse: () => CartItem(itemId: '', name: '', price: 0, quantity: 0),
    );
    return item.quantity;
  }
  bool containsItem(String itemId) {
    return _cart.items.any((item) => item.itemId == itemId);
  }
  static Future<void> initializeHive() async {
    await CartHiveService.init();
  }
  static Future<void> closeHive() async {
    await CartHiveService.close();
  }
}

