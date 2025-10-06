class PendingInvoiceModel {
  final int id;
  final String name;
  final String billNo;
  final DateTime dueDate;
  final DateTime billDate;
  final double debit;
  final double credit;
  final double outStandingAmount;
  final String type;

  PendingInvoiceModel({
    required this.id,
    required this.name,
    required this.billNo,
    required this.dueDate,
    required this.billDate,
    required this.debit,
    required this.credit,
    required this.outStandingAmount,
    required this.type,
  });

  factory PendingInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PendingInvoiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      billNo: json['billNo'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      billDate: DateTime.parse(json['billDate'] ?? DateTime.now().toIso8601String()),
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      outStandingAmount: (json['outStandingAmount'] ?? 0).toDouble(),
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'billNo': billNo,
      'dueDate': dueDate.toIso8601String(),
      'billDate': billDate.toIso8601String(),
      'debit': debit,
      'credit': credit,
      'outStandingAmount': outStandingAmount,
      'type': type,
    };
  }
}

class PendingInvoiceRequest {
  final String datefrom;
  final String dateto;
  final int customerId;
  final int costCentreId;
  final String type;

  PendingInvoiceRequest({
    required this.datefrom,
    required this.dateto,
    required this.customerId,
    this.costCentreId = 0,
    this.type = "string",
  });

  Map<String, dynamic> toJson() {
    return {
      'datefrom': datefrom,
      'dateto': dateto,
      'customerId': customerId,
      'costCentreId': costCentreId,
      'type': type,
    };
  }
}