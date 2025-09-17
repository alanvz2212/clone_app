import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/invoice_model.dart';
class InvoiceService {
  static const String _baseUrl = 'https://tmsapi.abm4trades.com';
  static const String _bearerToken = '659476889604ib26is5ods8ah9l';
  static const Duration _timeout = Duration(seconds: 30);
  final http.Client _client;
  InvoiceService({http.Client? client}) : _client = client ?? http.Client();
  Future<InvoiceResponse> getCustomerSales(int customerId) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl/Inventory/Sales/GetCustomerSales?customerId=$customerId',
      );
      final response = await _client
          .post(
            uri,
            headers: {
              'accept': '*/*',
              'Authorization': 'Bearer $_bearerToken',
              'Content-Type': 'application/json',
            },
            body: '',
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('API Response: $jsonData');
        return InvoiceResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw const HttpException('Unauthorized access');
      } else if (response.statusCode == 403) {
        throw const HttpException('Access forbidden');
      } else if (response.statusCode == 404) {
        throw const HttpException('Customer not found');
      } else if (response.statusCode >= 500) {
        throw const HttpException('Server error');
      } else {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const SocketException('No internet connection');
    } on HttpException {
      rethrow;
    } on FormatException {
      throw const FormatException('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
  Future<List<InvoiceModel>> getCustomerInvoices(int customerId) async {
    final response = await getCustomerSales(customerId);
    print('Response success: ${response.success}');
    print('Response message: ${response.message}');
    print('Response data length: ${response.data.length}');
    if (response.success) {
      return response.data;
    } else {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'Failed to fetch invoices',
      );
    }
  }
  void dispose() {
    _client.close();
  }
}

