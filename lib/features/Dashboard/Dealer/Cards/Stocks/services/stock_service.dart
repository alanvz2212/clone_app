import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';
import '../../../../../../constants/api_endpoints.dart';

class StockService {
  static const String baseUrl = 'http://devapi.abm4trades.com';
  static const String authToken = '659476889604ib26is5ods8ah9l';

  static Future<StockResponse?> getItemStockDetails(int itemId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/General/Item/ItemStockDetails?itemId=$itemId',
      );

      //  http://devapi.abm4trades.com/General/Item/MobileSearch?Search=sa

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
        print(
          'Failed to load stock details. Status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching stock details: $e');
      return null;
    }
  }

  static Future<StockResponse?> getItemStockDetailsByName(
    String itemName,
  ) async {
    try {
      // First, search for the item by name
      final searchUrl = Uri.parse(
        '${ApiEndpoints.itemSearch}?Search=$itemName',
      );

      final searchResponse = await http.post(
        searchUrl,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (searchResponse.statusCode == 200) {
        final Map<String, dynamic> searchData = json.decode(
          searchResponse.body,
        );
        final List<dynamic>? items = searchData['data'] as List<dynamic>?;

        if (items != null && items.isNotEmpty) {
          // Get the first matching item's ID
          final int itemId = items.first['id'] as int;

          // Now fetch stock details using the item ID
          return await getItemStockDetails(itemId);
        } else {
          print('No items found with name: $itemName');
          return null;
        }
      } else {
        print(
          'Failed to search items. Status code: ${searchResponse.statusCode}',
        );
        print('Response body: ${searchResponse.body}');
        return null;
      }
    } catch (e) {
      print('Error searching items by name: $e');
      return null;
    }
  }
}
