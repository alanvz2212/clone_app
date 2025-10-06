import 'package:equatable/equatable.dart';

abstract class PendingInvoiceEvent extends Equatable {
  const PendingInvoiceEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingInvoices extends PendingInvoiceEvent {}

class RefreshPendingInvoices extends PendingInvoiceEvent {}