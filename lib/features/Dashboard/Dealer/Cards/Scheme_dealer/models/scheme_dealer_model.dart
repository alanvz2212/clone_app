class SchemeDealerModel {
  final int schemeId;
  final String name;
  final String startDate;
  final String endDate;
  final int userType;
  final int point;
  final String fileName;

  SchemeDealerModel({
    required this.schemeId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.userType,
    required this.point,
    required this.fileName,
  });

  factory SchemeDealerModel.fromJson(Map<String, dynamic> json) {
    try {
      return SchemeDealerModel(
        schemeId: json['schemeId'] ?? 0,
        name: json['name'] ?? 'Unknown Scheme',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        userType: json['userType'] ?? 0,
        point: json['point'] ?? 0,
        fileName: json['fileName'] ?? '',
      );
    } catch (e) {
      print('Error parsing SchemeDealerModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'userType': userType,
      'point': point,
      'fileName': fileName,
    };
  }

  String get fullImageUrl => 'https://tmsapi.abm4trades.com/$fileName';
}

class SchemeDealerResponse {
  final bool success;
  final String message;
  final List<SchemeDealerModel> data;
  final dynamic additionalData;

  SchemeDealerResponse({
    required this.success,
    required this.message,
    required this.data,
    this.additionalData,
  });

  factory SchemeDealerResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing SchemeDealerService...');
      print('Response JSON: $json');

      List<SchemeDealerModel> schemes = [];

      if (json['data'] != null && json['data'] is List) {
        schemes = (json['data'] as List<dynamic>)
            .map((item) => SchemeDealerModel.fromJson(item))
            .toList();
      }

      return SchemeDealerResponse(
        success: json['success'] ?? true,
        message: json['message'] ?? '',
        data: schemes,
        additionalData: json['additionalData'],
      );
    } catch (e) {
      print('Error parsing SchemeDealerService: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}
