import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verify_otp_response.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class VerifyOtpService {
  Future<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final url = Uri.parse(ApiEndpoints.verifyOtp(phoneNumber, otp));
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('=== OTP Verification Response Debug ===');
        print('Response body: ${response.body}');
        print('Parsed JSON: $jsonData');
        print('=== End OTP Debug ===');
        return VerifyOtpResponse.fromJson(jsonData);
      } else {
        return VerifyOtpResponse(
          success: false,
          message: 'Failed to verify OTP. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return VerifyOtpResponse(
        success: false,
        message: 'Error verifying OTP: ${e.toString()}',
      );
    }
  }
}

