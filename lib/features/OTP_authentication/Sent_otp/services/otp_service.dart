import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_response_model.dart';

class OtpService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String bearerToken = '659476889604ib26is5ods8ah9l';

  Future<OtpResponseModel> sendOtp(String phoneNumber) async {
    try {
      final url = Uri.parse('$baseUrl/auth/Login/send-otp?phoneNumber=$phoneNumber');
      
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OtpResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }
}