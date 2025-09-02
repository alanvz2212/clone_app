import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_model.dart';

class FeedbackService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String feedbackEndpoint = '/General/FeedBack';
  static const String authToken = '659476889604ib26is5ods8ah9l';

  static Future<FeedbackResponse> submitFeedback(FeedbackRequest request) async {
    try {
      final url = Uri.parse('$baseUrl$feedbackEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
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
          message: 'Failed to submit feedback. Status code: ${response.statusCode}',
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