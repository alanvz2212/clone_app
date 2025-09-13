import 'package:dio/dio.dart';
import '../../../../../../../constants/api_endpoints.dart';
import '../../../../../../../services/api_service.dart';
import '../models/order_models.dart';

class OrdersService {
  final ApiService _apiService;

  OrdersService(this._apiService);

  Future<OrderResponse> getCustomerOrders(int customerId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        '${ApiEndpoints.customerOrders}?CustomerId=$customerId',
        data: {},
      );

      if (response.data != null) {
        return OrderResponse.fromJson(response.data!);
      } else {
        throw Exception('No data received from server');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Failed to fetch orders: ${e.message}');
      }
      throw Exception('Failed to fetch orders: $e');
    }
  }
}