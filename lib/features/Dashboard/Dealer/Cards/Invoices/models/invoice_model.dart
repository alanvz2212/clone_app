class InvoiceModel {
  final String invoice;
  final int invoiceIncrement;
  final String invoiceDate;
  final double total;
  final Customer customer;
  final Salesman salesman;
  InvoiceModel({
    required this.invoice,
    required this.invoiceIncrement,
    required this.invoiceDate,
    required this.total,
    required this.customer,
    required this.salesman,
  });
  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    try {
      return InvoiceModel(
        invoice: json['invoice'] ?? '',
        invoiceIncrement: json['invoiceIncrement'] ?? 0,
        invoiceDate: json['invoiceDate'] ?? '',
        total: (json['total'] ?? 0).toDouble(),
        customer: Customer.fromJson(json['customer'] ?? {}),
        salesman: Salesman.fromJson(json['salesman'] ?? {}),
      );
    } catch (e) {
      print('Error parsing InvoiceModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'invoice': invoice,
      'invoiceIncrement': invoiceIncrement,
      'invoiceDate': invoiceDate,
      'total': total,
      'customer': customer.toJson(),
      'salesman': salesman.toJson(),
    };
  }
}
class Customer {
  final String name;
  final String email;
  final String mobile;
  final String address;
  Customer({
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? 'Unknown Customer',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
    };
  }
}
class Salesman {
  final String name;
  final String email;
  final String mobile;
  Salesman({
    required this.name,
    required this.email,
    required this.mobile,
  });
  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      name: json['name'] ?? 'Unknown Salesman',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}
class InvoiceResponse {
  final bool success;
  final String message;
  final List<InvoiceModel> data;
  InvoiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing InvoiceResponse...');
      print('Success: ${json['success']}');
      print('Message: ${json['message']}');
      print('Data type: ${json['data'].runtimeType}');
      print('Data length: ${(json['data'] as List?)?.length ?? 0}');
      return InvoiceResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: (json['data'] as List<dynamic>?)
                ?.map((item) => InvoiceModel.fromJson(item))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing InvoiceResponse: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}

