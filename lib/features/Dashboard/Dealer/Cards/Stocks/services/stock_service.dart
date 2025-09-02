import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';

class StockService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String authToken = '659476889604ib26is5ods8ah9l';

  static Future<StockResponse?> getItemStockDetails(int itemId) async {
    try {
      final url = Uri.parse('$baseUrl/General/Item/ItemStockDetails?itemId=$itemId');
      
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return StockResponse.fromJson(jsonData);
      } else {
        print('Failed to load stock details. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching stock details: $e');
      return null;
    }
  }
}