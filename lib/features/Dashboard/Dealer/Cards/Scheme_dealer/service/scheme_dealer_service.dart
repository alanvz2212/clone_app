import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scheme_dealer_model.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class SchemeDealerService {
  Future<List<SchemeDealerModel>> getDealerSchemes(int userId) async {
    try {
      final url = Uri.parse(ApiEndpoints.schemeDealerWithId(userId));

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
          return jsonData.map((json) => SchemeDealerModel.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData['data'] != null && jsonData['data'] is List) {
            return (jsonData['data'] as List)
                .map((json) => SchemeDealerModel.fromJson(json))
                .toList();
          } else if (jsonData['data'] != null) {
            return [SchemeDealerModel.fromJson(jsonData['data'])];
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
