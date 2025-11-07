import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';

class MobileLogService {
  Future<bool> sendMobileLog({
    required int userId,
    required String userType,
    String? token,
  }) async {
    try {
      print('=== MOBILE LOG API CALL START ===');
      print('URL: ${ApiEndpoints.mobilelogs}');
      print('UserId: $userId');
      print('UserType: $userType');
      print(
        'Token: ${token != null ? "Present (${token.substring(0, 20)}...)" : "Not provided"}',
      );

      final requestBody = {
        'id': 0,
        'referenceId': 0,
        'referenceType': 'string',
        'companyId': 0,
        'userId': userId,
        'userType': userType,
      };

      print('Request Body: ${jsonEncode(requestBody)}');

      final headers = {'Content-Type': 'application/json'};

      // Add Authorization header if token is provided
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.post(
        Uri.parse(ApiEndpoints.mobilelogs),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ MOBILE LOG SENT SUCCESSFULLY!');
        print('=== MOBILE LOG API CALL END ===');
        return true;
      } else {
        print('❌ MOBILE LOG FAILED!');
        print('Status: ${response.statusCode}');
        print('Response: ${response.body}');
        print('=== MOBILE LOG API CALL END ===');
        return false;
      }
    } catch (e) {
      print('❌ MOBILE LOG ERROR!');
      print('Error: $e');
      print('=== MOBILE LOG API CALL END ===');
      return false;
    }
  }
}
