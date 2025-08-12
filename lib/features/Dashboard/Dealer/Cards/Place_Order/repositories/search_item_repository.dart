import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_item_model.dart';
import '../../../../../../constants/api_endpoints.dart';
import '../../../../../../constants/string_constants.dart';

class SearchItemRepository {
  Future<SearchItemResponse> searchItems(SearchItemRequest request) async {
    try {
      print(
        'Searching items with URL: ${ApiEndpoints.itemSearch}?Search=${request.search}',
      );
      print('Request body: ${jsonEncode(request.toJson())}');

      final response = await http.post(
        Uri.parse('${ApiEndpoints.itemSearch}?Search=${request.search}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return SearchItemResponse.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        return SearchItemResponse.failure(
          error:
              data['message'] ??
              data['error'] ??
              'Search failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Search error: $e');
      return SearchItemResponse.failure(
        error: 'Search failed: ${e.toString()}',
      );
    }
  }
}
