class SalesOrder {
  final int id;
  final String invoice;
  final double total;
  final DateTime invoiceDate;
  final String? orderstatus;

  SalesOrder({
    required this.id,
    required this.invoice,
    required this.total,
    required this.invoiceDate,
    this.orderstatus,
  });

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      id: json['id'],
      invoice: json['invoice'],
      total: json['total'].toDouble(),
      invoiceDate: DateTime.parse(json['invoiceDate']),
      orderstatus: json['orderstatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice': invoice,
      'total': total,
      'invoiceDate': invoiceDate.toIso8601String(),
      'orderstatus': orderstatus,
    };
  }
}