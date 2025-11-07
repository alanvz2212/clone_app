class SchemeSpecifierModel {
  final int schemeId;
  final String name;
  final String startDate;
  final String endDate;
  final int userType;
  final int point;
  final String fileName;

  SchemeSpecifierModel({
    required this.schemeId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.userType,
    required this.point,
    required this.fileName,
  });

  factory SchemeSpecifierModel.fromJson(Map<String, dynamic> json) {
    try {
      return SchemeSpecifierModel(
        schemeId: json['schemeId'] ?? 0,
        name: json['name'] ?? 'Unknown Scheme',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        userType: json['userType'] ?? 0,
        point: json['point'] ?? 0,
        fileName: json['fileName'] ?? '',
      );
    } catch (e) {
      print('Error parsing SchemeSpecifierModel: $e');
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

class SchemeSpecifierResponse {
  final bool success;
  final String message;
  final List<SchemeSpecifierModel> data;
  final dynamic additionalData;

  SchemeSpecifierResponse({
    required this.success,
    required this.message,
    required this.data,
    this.additionalData,
  });

  factory SchemeSpecifierResponse.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing SchemeSpecifierResponse...');
      print('Response JSON: $json');

      List<SchemeSpecifierModel> schemes = [];

      if (json['data'] != null && json['data'] is List) {
        schemes = (json['data'] as List<dynamic>)
            .map((item) => SchemeSpecifierModel.fromJson(item))
            .toList();
      }

      return SchemeSpecifierResponse(
        success: json['success'] ?? true,
        message: json['message'] ?? '',
        data: schemes,
        additionalData: json['additionalData'],
      );
    } catch (e) {
      print('Error parsing SchemeSpecifierResponse: $e');
      print('JSON: $json');
      rethrow;
    }
  }
}
