import 'package:equatable/equatable.dart';
import '../models/order_models.dart';
import 'orders_event.dart';
abstract class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}
class OrdersInitial extends OrdersState {
  const OrdersInitial();
}
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}
class OrdersRefreshing extends OrdersState {
  final List<OrderData> orders;
  final List<OrderData> filteredOrders;
  final DateFilter currentFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  const OrdersRefreshing({
    required this.orders,
    required this.filteredOrders,
    required this.currentFilter,
    this.customStartDate,
    this.customEndDate,
  });
  @override
  List<Object?> get props => [
        orders,
        filteredOrders,
        currentFilter,
        customStartDate,
        customEndDate,
      ];
}
class OrdersLoaded extends OrdersState {
  final List<OrderData> orders;
  final List<OrderData> filteredOrders;
  final DateFilter currentFilter;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  const OrdersLoaded({
    required this.orders,
    required this.filteredOrders,
    required this.currentFilter,
    this.customStartDate,
    this.customEndDate,
  });
  @override
  List<Object?> get props => [
        orders,
        filteredOrders,
        currentFilter,
        customStartDate,
        customEndDate,
      ];
  OrdersLoaded copyWith({
    List<OrderData>? orders,
    List<OrderData>? filteredOrders,
    DateFilter? currentFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      currentFilter: currentFilter ?? this.currentFilter,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
    );
  }
}
class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);
  @override
  List<Object> get props => [message];
}
class OrdersEmpty extends OrdersState {
  const OrdersEmpty();
}

