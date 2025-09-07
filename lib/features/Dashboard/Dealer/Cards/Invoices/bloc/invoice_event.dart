import 'package:equatable/equatable.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

class LoadInvoices extends InvoiceEvent {
  final int customerId;

  const LoadInvoices({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class RefreshInvoices extends InvoiceEvent {
  final int customerId;

  const RefreshInvoices({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class RetryLoadInvoices extends InvoiceEvent {
  final int customerId;

  const RetryLoadInvoices({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}