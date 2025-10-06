import 'package:equatable/equatable.dart';
import '../models/pending_invoice_model.dart';

abstract class PendingInvoiceState extends Equatable {
  const PendingInvoiceState();

  @override
  List<Object> get props => [];
}

class PendingInvoiceInitial extends PendingInvoiceState {}

class PendingInvoiceLoading extends PendingInvoiceState {}

class PendingInvoiceLoaded extends PendingInvoiceState {
  final List<PendingInvoiceModel> invoices;

  const PendingInvoiceLoaded(this.invoices);

  @override
  List<Object> get props => [invoices];
}

class PendingInvoiceError extends PendingInvoiceState {
  final String message;

  const PendingInvoiceError(this.message);

  @override
  List<Object> get props => [message];
}