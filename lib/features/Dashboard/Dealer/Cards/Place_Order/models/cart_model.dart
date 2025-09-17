class CartItem {
  final String itemId;
  final String name;
  final double price;
  int quantity;
  CartItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });
  double get total => price * quantity;
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['itemId'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}
class Cart {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.total);
  void addItem(String itemId, String name, double price, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.itemId == itemId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = quantity;
      if (_items[existingIndex].quantity <= 0) {
        _items.removeAt(existingIndex);
      }
    } else if (quantity > 0) {
      _items.add(CartItem(
        itemId: itemId,
        name: name,
        price: price,
        quantity: quantity,
      ));
    }
  }
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.itemId == itemId);
  }
  void updateQuantity(String itemId, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.itemId == itemId);
    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(existingIndex);
      } else {
        _items[existingIndex].quantity = quantity;
      }
    }
  }
  void clear() {
    _items.clear();
  }
  bool isEmpty() => _items.isEmpty;
}

