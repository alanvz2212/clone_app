class OrderResponse {
  final bool success;
  final List<OrderData> orders;
  OrderResponse({
    required this.success,
    required this.orders,
  });
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
class OrderData {
  final Order order;
  final List<OrderItem> items;
  OrderData({
    required this.order,
    required this.items,
  });
  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
class Order {
  final int id;
  final String invoice;
  final int customerId;
  final Customer? customer;
  final MobileOrderStatus? mobileOrderStatus;
  final String? notes;
  final Company? company;
  final DateTime createdDate;
  final DateTime updatedDate;
  Order({
    required this.id,
    required this.invoice,
    required this.customerId,
    this.customer,
    this.mobileOrderStatus,
    this.notes,
    this.company,
    required this.createdDate,
    required this.updatedDate,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: _parseToInt(json['id']) ?? 0,
      invoice: json['invoice'] ?? '',
      customerId: _parseToInt(json['customerId']) ?? 0,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      mobileOrderStatus: json['mobileOrderStatus'] != null
          ? MobileOrderStatus.fromJson(
              json['mobileOrderStatus'] as Map<String, dynamic>)
          : null,
      notes: json['notes'],
      company: json['company'] != null
          ? Company.fromJson(json['company'] as Map<String, dynamic>)
          : null,
      createdDate: DateTime.parse(json['createdDate'] ?? DateTime.now().toIso8601String()),
      updatedDate: DateTime.parse(json['updatedDate'] ?? DateTime.now().toIso8601String()),
    );
  }
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
class Customer {
  final String name;
  final String? email;
  final String? mobile;
  final String? address;
  final String? gstNo;
  final String? panNo;
  Customer({
    required this.name,
    this.email,
    this.mobile,
    this.address,
    this.gstNo,
    this.panNo,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'],
      gstNo: json['gstNo'],
      panNo: json['panNo'],
    );
  }
}
class MobileOrderStatus {
  final String name;
  final bool isCompleted;
  MobileOrderStatus({
    required this.name,
    required this.isCompleted,
  });
  factory MobileOrderStatus.fromJson(Map<String, dynamic> json) {
    return MobileOrderStatus(
      name: json['name'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
class Company {
  final String companyName;
  final String? phoneNumber;
  final String? logo;
  Company({
    required this.companyName,
    this.phoneNumber,
    this.logo,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyName: json['companyName'] ?? '',
      phoneNumber: json['phoneNumber'],
      logo: json['logo'],
    );
  }
}
class OrderItem {
  final int id;
  final int mobileOrderId;
  final int itemId;
  final int itemQuantity;
  final int completedQuantity;
  final DateTime createdDate;
  OrderItem({
    required this.id,
    required this.mobileOrderId,
    required this.itemId,
    required this.itemQuantity,
    required this.completedQuantity,
    required this.createdDate,
  });
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: _parseToInt(json['id']) ?? 0,
      mobileOrderId: _parseToInt(json['mobileOrderId']) ?? 0,
      itemId: _parseToInt(json['itemId']) ?? 0,
      itemQuantity: _parseToInt(json['itemQuantity']) ?? 0,
      completedQuantity: _parseToInt(json['completedQuantity']) ?? 0,
      createdDate: DateTime.parse(json['createdDate'] ?? DateTime.now().toIso8601String()),
    );
  }
  static int? _parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

