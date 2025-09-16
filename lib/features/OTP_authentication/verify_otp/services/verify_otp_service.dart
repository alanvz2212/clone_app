import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verify_otp_response.dart';

class VerifyOtpService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String authToken = '659476889604ib26is5ods8ah9l';

  Future<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/Login/verify-otp?phoneNumber=$phoneNumber&otp=$otp');
      
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
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