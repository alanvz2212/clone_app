import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dues_model.dart';

class DuesService {
  static const String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API base URL
  
  Future<List<DuesModel>> fetchDues(DuesRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dues'), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers like authorization if needed
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => DuesModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dues: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dues: $e');
    }
  }

  // Mock data for testing - remove this when you have actual API
  Future<List<DuesModel>> fetchMockDues() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data based on your JSON structure
    final mockData = [
      {
        "id": 55685,
        "name": "Saaf Ply",
        "billNo": "25-26-CLT00032",
        "dueDate": "2025-05-02T00:00:00",
        "billDate": "2025-04-02T00:00:00",
        "debit": 2220,
        "credit": 0,
        "outStandingAmount": 2220,
        "type": "Dr"
      },
      {
        "id": 55768,
        "name": "Saaf Ply",
        "billNo": "25-26-CLT00069",
        "dueDate": "2025-05-02T00:00:00",
        "billDate": "2025-04-02T00:00:00",
        "debit": 9390,
        "credit": 0,
        "outStandingAmount": 9390,
        "type": "Dr"
      },
      {
        "id": 65057,
        "name": "Saaf Ply",
        "billNo": "SRTN00025",
        "dueDate": "2025-05-30T00:00:00",
        "billDate": "2025-04-30T00:00:00",
        "debit": 0,
        "credit": 917,
        "outStandingAmount": 917,
        "type": "Cr"
      },
    ];
    
    return mockData.map((json) => DuesModel.fromJson(json)).toList();
  }
}