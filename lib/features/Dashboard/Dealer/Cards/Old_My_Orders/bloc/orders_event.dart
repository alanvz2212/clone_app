import 'package:equatable/equatable.dart';

enum DateFilter {
  all,
  today,
  thisWeek,
  thisMonth,
  last30Days,
  custom,
}

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrdersEvent {
  final int customerId;

  const FetchOrders(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class RefreshOrders extends OrdersEvent {
  final int customerId;

  const RefreshOrders(this.customerId);

  @override
  List<Object> get props => [customerId];
}

class FilterOrders extends OrdersEvent {
  final DateFilter filter;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterOrders({
    required this.filter,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [filter, startDate, endDate];
}

class ClearOrders extends OrdersEvent {
  const ClearOrders();
}