import 'dart:convert';
import 'dart:io';
import 'package:clone/constants/api_endpoints.dart';
import 'package:clone/constants/string_constants.dart';
import 'package:http/http.dart' as http;

import 'package:clone/features/Contact_Support/model/contact_us_model.dart';

class ContactUsService {
  static Future<ContactUsResponse> submitContactUs(
    ContactUsRequest request,
    File gstCertificateFile,
  ) async {
    try {
      final url = Uri.parse(ApiEndpoints.contactUsEndpoint);

      // Create multipart request
      var multipartRequest = http.MultipartRequest('POST', url);

      // Add headers
      multipartRequest.headers.addAll({
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      });

      // Add form fields
      multipartRequest.fields['id'] = request.id.toString();
      multipartRequest.fields['referenceId'] = request.referenceId.toString();
      multipartRequest.fields['referenceType'] = request.referenceType;
      multipartRequest.fields['companyId'] = request.companyId.toString();
      multipartRequest.fields['whatsappNumber'] = request.whatsappNumber;
      multipartRequest.fields['contactNumber'] = request.contactNumber;
      multipartRequest.fields['companyName'] = request.companyName;
      multipartRequest.fields['companyAddress'] = request.companyAddress;
      multipartRequest.fields['companyGST'] = request.companyGST;

      // Add file - read file bytes and upload
      var fileBytes = await gstCertificateFile.readAsBytes();
      var fileName = gstCertificateFile.path.split('/').last;

      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'gstCertificate', // Field name expected by backend
          fileBytes,
          filename: fileName,
        ),
      );

      // Send request
      var streamedResponse = await multipartRequest.send();
      var response = await http.Response.fromStream(streamedResponse);

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
