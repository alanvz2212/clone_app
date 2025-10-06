import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/pending_invoice_service.dart';
import 'pending_invoice_event.dart';
import 'pending_invoice_state.dart';

class PendingInvoiceBloc extends Bloc<PendingInvoiceEvent, PendingInvoiceState> {
  final PendingInvoiceService _service;

  PendingInvoiceBloc(this._service) : super(PendingInvoiceInitial()) {
    on<LoadPendingInvoices>(_onLoadPendingInvoices);
    on<RefreshPendingInvoices>(_onRefreshPendingInvoices);
  }

  Future<void> _onLoadPendingInvoices(
    LoadPendingInvoices event,
    Emitter<PendingInvoiceState> emit,
  ) async {
    emit(PendingInvoiceLoading());
    try {
      final invoices = await _service.fetchPendingInvoices();
      emit(PendingInvoiceLoaded(invoices));
    } catch (e) {
      emit(PendingInvoiceError(e.toString()));
    }
  }

  Future<void> _onRefreshPendingInvoices(
    RefreshPendingInvoices event,
    Emitter<PendingInvoiceState> emit,
  ) async {
    try {
      final invoices = await _service.fetchPendingInvoices();
      emit(PendingInvoiceLoaded(invoices));
    } catch (e) {
      emit(PendingInvoiceError(e.toString()));
    }
  }
}