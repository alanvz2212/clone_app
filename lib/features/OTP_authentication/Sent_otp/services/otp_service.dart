import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/otp_response_model.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class OtpService {
  Future<OtpResponseModel> sendOtp(String phoneNumber) async {
    try {
      if (phoneNumber.isEmpty || phoneNumber.length != 10) {
        throw Exception('Invalid phone number');
      }

      final url = Uri.parse(ApiEndpoints.sendOtp(phoneNumber));
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
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
      throw Exception('Invalid phone number');
    }
  }
}
