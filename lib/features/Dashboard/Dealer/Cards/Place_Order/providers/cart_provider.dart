import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();
  
  Cart get cart => _cart;
  
  List<CartItem> get items => _cart.items;
  
  int get totalItems => _cart.totalItems;
  
  double get totalAmount => _cart.totalAmount;
  
  bool get isEmpty => _cart.isEmpty();
  
  void addItem(String itemId, String name, double price, int quantity) {
    _cart.addItem(itemId, name, price, quantity);
    notifyListeners();
  }
  
  void removeItem(String itemId) {
    _cart.removeItem(itemId);
    notifyListeners();
  }
  
  void updateQuantity(String itemId, int quantity) {
    _cart.updateQuantity(itemId, quantity);
    notifyListeners();
  }
  
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
  
  CartItem? getItem(String itemId) {
    try {
      return _cart.items.firstWhere((item) => item.itemId == itemId);
    } catch (e) {
      return null;
    }
  }
}