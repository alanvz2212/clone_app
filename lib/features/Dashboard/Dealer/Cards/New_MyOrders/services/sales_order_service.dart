import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sales_order_model.dart';

class SalesOrderService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String authToken = '659476889604ib26is5ods8ah9l';

  static Future<List<SalesOrder>> getCustomerSalesOrders(int customerId) async {
    try {
      final url = Uri.parse('$baseUrl/Inventory/SalesOrder/GetCustomerSalesOrder?customerId=$customerId');
      
      final response = await http.post(
        url,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      print('API Request URL: $url');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => SalesOrder.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sales orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getCustomerSalesOrders: $e');
      throw Exception('Error fetching sales orders: $e');
    }
  }
}