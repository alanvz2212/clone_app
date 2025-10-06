import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock_model.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class StockService {
  Future<StockResponse> getItemStock(String itemId) async {
    try {
      final url = Uri.parse(ApiEndpoints.itemStockWithId(itemId));
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return StockResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> searchItems(String itemName) async {
    try {
      final searchUrl = Uri.parse(ApiEndpoints.itemSearchWithQuery(itemName));
      final searchResponse = await http.post(
        searchUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: '',
      );

      if (searchResponse.statusCode == 200) {
        final jsonData = json.decode(searchResponse.body);
        return jsonData['data'] ?? [];
      } else {
        throw Exception('Failed to search items');
      }
    } catch (e) {
      throw Exception('Error searching items: $e');
    }
  }

  static Future<StockResponse?> getItemStockDetails(int itemId) async {
    try {
      final url = Uri.parse(
        '${ApiEndpoints.baseUrl}/General/Item/ItemStockDetails?itemId=$itemId',
      );
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
      final searchUrl = Uri.parse(
        '${ApiEndpoints.itemSearch}?Search=$itemName',
      );
      final searchResponse = await http.post(
        searchUrl,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
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
          final int itemId = items.first['id'] as int;
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
