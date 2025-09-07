import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../models/invoice_model.dart';
import '../services/invoice_service.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceService _invoiceService;
  final Logger _logger = Logger();

  InvoiceBloc({InvoiceService? invoiceService})
    : _invoiceService = invoiceService ?? InvoiceService(),
      super(InvoiceInitial()) {
    on<LoadInvoices>(_onLoadInvoices);
    on<RefreshInvoices>(_onRefreshInvoices);
    on<RetryLoadInvoices>(_onRetryLoadInvoices);
  }

  Future<void> _onLoadInvoices(
    LoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      emit(InvoiceLoading());
      _logger.i('Loading invoices for customer: ${event.customerId}');

      final invoices = await _invoiceService.getCustomerInvoices(
        event.customerId,
      );

      if (invoices.isEmpty) {
        emit(InvoiceEmpty(customerId: event.customerId));
      } else {
        emit(InvoiceLoaded(invoices: invoices, customerId: event.customerId));
      }

      _logger.i('Successfully loaded ${invoices.length} invoices');
    } catch (error) {
      _logger.e('Error loading invoices: $error');
      emit(
        InvoiceError(
          message: _getErrorMessage(error),
          customerId: event.customerId,
        ),
      );
    }
  }

  Future<void> _onRefreshInvoices(
    RefreshInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      // Show refreshing state with current data if available
      if (state is InvoiceLoaded) {
        final currentState = state as InvoiceLoaded;
        emit(InvoiceRefreshing(currentInvoices: currentState.invoices));
      } else {
        emit(InvoiceLoading());
      }

      _logger.i('Refreshing invoices for customer: ${event.customerId}');

      final invoices = await _invoiceService.getCustomerInvoices(
        event.customerId,
      );

      if (invoices.isEmpty) {
        emit(InvoiceEmpty(customerId: event.customerId));
      } else {
        emit(InvoiceLoaded(invoices: invoices, customerId: event.customerId));
      }

      _logger.i('Successfully refreshed ${invoices.length} invoices');
    } catch (error) {
      _logger.e('Error refreshing invoices: $error');
      emit(
        InvoiceError(
          message: _getErrorMessage(error),
          customerId: event.customerId,
        ),
      );
    }
  }

  Future<void> _onRetryLoadInvoices(
    RetryLoadInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    _logger.i('Retrying to load invoices for customer: ${event.customerId}');
    add(LoadInvoices(customerId: event.customerId));
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout. Please try again.';
    } else if (error.toString().contains('FormatException')) {
      return 'Invalid data format received from server.';
    } else if (error.toString().contains('401')) {
      return 'Authentication failed. Please login again.';
    } else if (error.toString().contains('403')) {
      return 'Access denied. You don\'t have permission to view this data.';
    } else if (error.toString().contains('404')) {
      return 'Data not found on server.';
    } else if (error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
