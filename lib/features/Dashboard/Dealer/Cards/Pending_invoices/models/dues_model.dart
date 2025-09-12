class DuesModel {
  final int id;
  final String name;
  final String billNo;
  final DateTime dueDate;
  final DateTime billDate;
  final double debit;
  final double credit;
  final double outStandingAmount;
  final String type;

  DuesModel({
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

  factory DuesModel.fromJson(Map<String, dynamic> json) {
    return DuesModel(
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

class DuesRequest {
  final String dateFrom;
  final String dateTo;
  final int customerId;
  final int costCentreId;
  final String type;

  DuesRequest({
    required this.dateFrom,
    required this.dateTo,
    required this.customerId,
    this.costCentreId = 0,
    this.type = "string",
  });

  Map<String, dynamic> toJson() {
    return {
      'datefrom': dateFrom,
      'dateto': dateTo,
      'customerId': customerId,
      'costCentreId': costCentreId,
      'type': type,
    };
  }
}