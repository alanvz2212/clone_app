import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pending_invoice_model.dart';
import 'package:abm4customerapp/core/di/injection.dart';
import 'package:abm4customerapp/services/user_service.dart';
import 'package:abm4customerapp/services/auth_service.dart';

class PendingInvoiceService {
  static const String apiUrl =
      'https://tmsapi.abm4trades.com/Reports/Accounts/CustomerDueReport';

  Future<List<PendingInvoiceModel>> fetchPendingInvoices() async {
    try {
      print(' Starting fetchPendingInvoices...');

      final userService = getIt<UserService>();
      final currentCustomerId = await userService
          .getCurrentCustomerIdWithFallback();

      print(' Customer ID: $currentCustomerId');

      if (currentCustomerId <= 0) {
        throw Exception(
          'Invalid customer ID: $currentCustomerId. Please login again.',
        );
      }

      String? token;
      try {
        final authService = getIt<AuthService>();
        token = await authService.getToken();
        print(
          ' Token: ${token != null ? "Present (${token.length} chars)" : "Missing"}',
        );
      } catch (e) {
        print(' Error getting token: $e');
        throw Exception('Authentication token not found. Please login again.');
      }

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing. Please login again.');
      }

      final request = PendingInvoiceRequest(
        datefrom: "2020-01-01",
        dateto: "2030-12-31",
        customerId: currentCustomerId,
        costCentreId: 0,
        type: "string",
      );

      final requestBody = jsonEncode(request.toJson());
      print(' Request URL: $apiUrl');
      print(' Request Body: $requestBody');

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: requestBody,
          )
          .timeout(const Duration(seconds: 30));

      print(' Response Status: ${response.statusCode}');
      print(' Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        List<dynamic> jsonData;
        if (responseData is List) {
          jsonData = responseData;
          print(' Response is direct array with ${jsonData.length} items');
        } else if (responseData is Map && responseData.containsKey('data')) {
          jsonData = responseData['data'] as List;
          print(' Response has data wrapper with ${jsonData.length} items');
        } else if (responseData is Map && responseData.containsKey('result')) {
          jsonData = responseData['result'] as List;
          print(' Response has result wrapper with ${jsonData.length} items');
        } else {
          print(' Unexpected response format: ${responseData.runtimeType}');
          print(' Response content: $responseData');
          throw Exception(
            'Unexpected response format: ${responseData.runtimeType}',
          );
        }

        final invoices = jsonData
            .map((json) => PendingInvoiceModel.fromJson(json))
            .toList();
        print(' Successfully parsed ${invoices.length} pending invoices');
        return invoices;
      } else {
        print(' HTTP Error: ${response.statusCode}');
        print(' Error Body: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print(' Exception in fetchPendingInvoices: $e');

      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception(
          'Network error. Please check your internet connection.',
        );
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid response format from server.');
      } else {
        throw Exception('Error: $e');
      }
    }
  }
}
