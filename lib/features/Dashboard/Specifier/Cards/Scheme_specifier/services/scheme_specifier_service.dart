import 'dart:convert';

import 'package:abm4customerapp/constants/api_endpoints.dart';
import 'package:abm4customerapp/constants/string_constants.dart';
import 'package:abm4customerapp/features/Dashboard/Specifier/Cards/Scheme_specifier/model/scheme_specifier_model.dart';
import 'package:http/http.dart' as http;

class SchemeSpecifierService {
  Future<List<SchemeSpecifierModel>> getSpecfierSchemes(int userId) async {
    try {
      final url = Uri.parse(ApiEndpoints.schemeSpecifierWithId(userId));

      print('API Request URL: $url');
      print('User ID: $userId');
      print('Token: $token');

      final response = await http.get(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        if (jsonData is List) {
          return jsonData
              .map((json) => SchemeSpecifierModel.fromJson(json))
              .toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData['data'] != null && jsonData['data'] is List) {
            return (jsonData['data'] as List)
                .map((json) => SchemeSpecifierModel.fromJson(json))
                .toList();
          } else if (jsonData['data'] != null) {
            return [SchemeSpecifierModel.fromJson(jsonData['data'])];
          }
        }

        return [];
      } else if (response.statusCode == 404) {
        print('No schemes found for user: $userId');
        return [];
      } else {
        throw Exception('Failed to load schemes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCustomerSchemes: $e');
      throw Exception('Error fetching schemes: $e');
    }
  }
}
