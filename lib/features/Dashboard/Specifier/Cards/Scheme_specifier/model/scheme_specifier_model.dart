
class SchemeSpecifierModel {
  final int schemeId;
  final String name;
  final String fileName;
  final String startDate;
  final String endDate;
  final int userType;
  final int point;

  SchemeSpecifierModel({
    required this.schemeId,
    required this.name,
    required this.fileName,
    required this.startDate,
    required this.endDate,
    required this.userType,
    required this.point,
  });

  factory SchemeSpecifierModel.fromJson(Map<String, dynamic> json) {
    try {
      return SchemeSpecifierModel(
        schemeId: json['schemeId'] ?? 0,
        name: json['name'] ?? 'Unknown Scheme',
        fileName: json['fileName'] ?? '',
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        userType: json['userType'] ?? 0,
        point: json['point'] ?? 0,
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
      'fileName': fileName,
      'startDate': startDate,
      'endDate': endDate,
      'userType': userType,
      'point': point,
    };
  }
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
