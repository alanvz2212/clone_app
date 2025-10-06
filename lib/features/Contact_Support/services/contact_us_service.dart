import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/contact_us_model.dart';
import '../../../constants/api_endpoints.dart';
import '../../../constants/string_constants.dart';

class ContactUsService {
  static Future<ContactUsResponse> submitContactUs(
    ContactUsRequest request,
  ) async {
    try {
      final url = Uri.parse(ApiEndpoints.contactUsEndpoint);
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
        return ContactUsResponse.fromJson(responseData);
      } else {
        return ContactUsResponse(
          success: false,
          message:
              'Failed to submit contact request. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ContactUsResponse(
        success: false,
        message: 'Error submitting contact request: $e',
      );
    }
  }
}
