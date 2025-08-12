import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dealer_auth_model.dart';
import '../../../../constants/api_endpoints.dart';
import '../../../../constants/string_constants.dart';

class DealerAuthRepository {
  final String baseUrl;

  DealerAuthRepository({required this.baseUrl});

  Future<DealerLoginResponse> login(DealerLoginRequest request) async {
    try {
      print('Attempting dealer login with URL: ${ApiEndpoints.customerLogin}');
      print('Request body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        Uri.parse(ApiEndpoints.customerLogin),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return DealerLoginResponse.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        return DealerLoginResponse.failure(
          error:
              data['message'] ??
              data['error'] ??
              'Login failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Login error: $e');
      return DealerLoginResponse.failure(
        error: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<bool> forgotPassword(DealerForgotPasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.forgotPassword}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] as bool? ?? false;
      }
      return false;
    } catch (e) {
      print('Forgot password error: $e');
      return false;
    }
  }

  Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.logout}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] as bool? ?? false;
      }
      return false;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }
}
