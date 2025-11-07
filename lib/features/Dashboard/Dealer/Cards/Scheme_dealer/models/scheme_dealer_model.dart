class SchemeDealerModel {
  final int schemeId;
  final String name;
  final String fileName;
  final String startDate;
  final String endDate;
  final int userType;
  final int point;

  SchemeDealerModel({
    required this.schemeId,
    required this.name,
    required this.fileName,
    required this.startDate,
    required this.endDate,
    required this.userType,
    required this.point,
  });

  factory SchemeDealerModel.fromJson(Map<String, dynamic> json) {
    try {
      return SchemeDealerModel(
        schemeId: json['schemeId'] ?? 0,
        name: json['name'] ?? 'Unknown Scheme',
        fileName: json['fileName'] ?? '',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        userType: json['userType'] ?? 0,
        point: json['point'] ?? 0,
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
      'fileName': fileName,
      'startDate': startDate,
      'endDate': endDate,
      'userType': userType,
      'point': point,
    };
  }
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
