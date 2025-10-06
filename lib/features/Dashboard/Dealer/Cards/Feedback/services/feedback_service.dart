import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_model.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class FeedbackService {
  static Future<FeedbackResponse> submitFeedback(
    FeedbackRequest request,
  ) async {
    try {
      final url = Uri.parse(ApiEndpoints.feedbackEndpoint);
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
        return FeedbackResponse.fromJson(responseData);
      } else {
        return FeedbackResponse(
          success: false,
          message:
              'Failed to submit feedback. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return FeedbackResponse(
        success: false,
        message: 'Error submitting feedback: $e',
      );
    }
  }
}

