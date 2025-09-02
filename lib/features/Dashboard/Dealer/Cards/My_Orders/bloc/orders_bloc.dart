import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/orders_service.dart';
import '../models/order_models.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersService ordersService;

  OrdersBloc({required this.ordersService}) : super(const OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<RefreshOrders>(_onRefreshOrders);
    on<FilterOrders>(_onFilterOrders);
    on<ClearOrders>(_onClearOrders);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());

    try {
      final orderResponse = await ordersService.getCustomerOrders(event.customerId);
      
      if (orderResponse.success && orderResponse.orders.isNotEmpty) {
        emit(OrdersLoaded(
          orders: orderResponse.orders,
          filteredOrders: orderResponse.orders,
          currentFilter: DateFilter.all,
        ));
      } else if (orderResponse.orders.isEmpty) {
        emit(const OrdersEmpty());
      } else {
        emit(const OrdersError('Failed to load orders'));
      }
    } catch (e) {
      emit(OrdersError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is OrdersLoaded) {
      emit(OrdersRefreshing(
        orders: currentState.orders,
        filteredOrders: currentState.filteredOrders,
        currentFilter: currentState.currentFilter,
        customStartDate: currentState.customStartDate,
        customEndDate: currentState.customEndDate,
      ));
    }

    try {
      final orderResponse = await ordersService.getCustomerOrders(event.customerId);
      
      if (orderResponse.success && orderResponse.orders.isNotEmpty) {
        final filteredOrders = currentState is OrdersLoaded
            ? _applyDateFilter(
                orderResponse.orders,
                currentState.currentFilter,
                currentState.customStartDate,
                currentState.customEndDate,
              )
            : orderResponse.orders;

        emit(OrdersLoaded(
          orders: orderResponse.orders,
          filteredOrders: filteredOrders,
          currentFilter: currentState is OrdersLoaded 
              ? currentState.currentFilter 
              : DateFilter.all,
          customStartDate: currentState is OrdersLoaded 
              ? currentState.customStartDate 
              : null,
          customEndDate: currentState is OrdersLoaded 
              ? currentState.customEndDate 
              : null,
        ));
      } else if (orderResponse.orders.isEmpty) {
        emit(const OrdersEmpty());
      } else {
        emit(const OrdersError('Failed to refresh orders'));
      }
    } catch (e) {
      emit(OrdersError('Error: ${e.toString()}'));
    }
  }

  void _onFilterOrders(
    FilterOrders event,
    Emitter<OrdersState> emit,
  ) {
    final currentState = state;
    
    if (currentState is OrdersLoaded) {
      final filteredOrders = _applyDateFilter(
        currentState.orders,
        event.filter,
        event.startDate,
        event.endDate,
      );

      emit(currentState.copyWith(
        filteredOrders: filteredOrders,
        currentFilter: event.filter,
        customStartDate: event.startDate,
        customEndDate: event.endDate,
      ));
    }
  }

  void _onClearOrders(
    ClearOrders event,
    Emitter<OrdersState> emit,
  ) {
    emit(const OrdersInitial());
  }

  List<OrderData> _applyDateFilter(
    List<OrderData> orders,
    DateFilter filter,
    DateTime? customStartDate,
    DateTime? customEndDate,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case DateFilter.all:
        return List.from(orders);
      
      case DateFilter.today:
        return orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAtSameMomentAs(today);
        }).toList();
      
      case DateFilter.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                 orderDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      
      case DateFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                 orderDate.isBefore(endOfMonth.add(const Duration(days: 1)));
        }).toList();
      
      case DateFilter.last30Days:
        final thirtyDaysAgo = today.subtract(const Duration(days: 30));
        return orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(thirtyDaysAgo.subtract(const Duration(days: 1)));
        }).toList();
      
      case DateFilter.custom:
        if (customStartDate != null && customEndDate != null) {
          return orders.where((orderData) {
            final orderDate = DateTime(
              orderData.order.createdDate.year,
              orderData.order.createdDate.month,
              orderData.order.createdDate.day,
            );
            return orderDate.isAfter(customStartDate.subtract(const Duration(days: 1))) &&
                   orderDate.isBefore(customEndDate.add(const Duration(days: 1)));
          }).toList();
        } else {
          return List.from(orders);
        }
    }
  }
}