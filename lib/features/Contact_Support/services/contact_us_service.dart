import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/contact_us_model.dart';
import '../../../constants/api_endpoints.dart';
import '../../../constants/string_constants.dart';

class ContactUsService {
  static Future<ContactUsResponse> submitContactUs(
    ContactUsRequest request,
    File gstCertificateFile,
  ) async {
    try {
      final url = Uri.parse(ApiEndpoints.contactUsEndpoint);

      var fileBytes = await gstCertificateFile.readAsBytes();
      String base64File = base64Encode(fileBytes);

      final Map<String, dynamic> requestBody = {
        'id': request.id,
        'referenceId': request.referenceId,
        'referenceType': request.referenceType,
        'companyId': request.companyId,
        'whatsappNumber': request.whatsappNumber,
        'contactNumber': request.contactNumber,
        'companyName': request.companyName,
        'companyAddress': request.companyAddress,
        'companyGST': request.companyGST,
        'gstCertificate': base64File,
      };

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return ContactUsResponse.fromJson(responseData);
      } else {
        return ContactUsResponse(
          success: false,
          message:
              'Failed to submit contact request. Status code: ${response.statusCode}. Response: ${response.body}',
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
