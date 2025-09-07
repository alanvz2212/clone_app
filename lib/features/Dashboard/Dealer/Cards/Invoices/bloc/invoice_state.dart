import 'package:equatable/equatable.dart';
import '../models/invoice_model.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceRefreshing extends InvoiceState {
  final List<InvoiceModel> currentInvoices;

  const InvoiceRefreshing({required this.currentInvoices});

  @override
  List<Object?> get props => [currentInvoices];
}

class InvoiceLoaded extends InvoiceState {
  final List<InvoiceModel> invoices;
  final int customerId;

  const InvoiceLoaded({required this.invoices, required this.customerId});

  @override
  List<Object?> get props => [invoices, customerId];
}

class InvoiceEmpty extends InvoiceState {
  final int customerId;

  const InvoiceEmpty({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class InvoiceError extends InvoiceState {
  final String message;
  final int customerId;

  const InvoiceError({required this.message, required this.customerId});

  @override
  List<Object?> get props => [message, customerId];
}
