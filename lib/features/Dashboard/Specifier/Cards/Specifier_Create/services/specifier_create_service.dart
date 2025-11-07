import 'dart:convert';

import 'package:clone/constants/api_endpoints.dart';
import 'package:clone/constants/string_constants.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Specifier_Create/model/specifier_create_model.dart';
import 'package:http/http.dart' as http;

class SpecifierCreateService {
  static Future<SpecifierCreateResponse> submitSpecifierCreate(
    SpecifierCreateRequest request,
  ) async {
    try {
      final url = Uri.parse(ApiEndpoints.specifiercreateEndpoint);
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return SpecifierCreateResponse.fromJson(responseData);
      } else {
        return SpecifierCreateResponse(
          success: false,
          message:
              'Failed to submit contact request. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return SpecifierCreateResponse(
        success: false,
        message: 'Error submitting contact request: $e',
      );
    }
  }
}
