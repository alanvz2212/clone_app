import 'package:abm4customerapp/features/Dashboard/Dealer/Cards/Place_Order/Screen/Place_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/di/injection.dart';
import '../../../../../../../services/api_service.dart';
import '../../../../../../../services/user_service.dart';
import '../models/order_models.dart';
import '../services/orders_service.dart';
import '../bloc/bloc.dart';
import '../../../../../../../constants/string_constants.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late OrdersBloc _ordersBloc;
  late UserService _userService;
  int? _currentCustomerId;
  @override
  void initState() {
    super.initState();
    _userService = getIt<UserService>();
    _ordersBloc = OrdersBloc(ordersService: OrdersService(getIt<ApiService>()));
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _currentCustomerId = await _userService.getCurrentCustomerIdWithFallback();
    _ordersBloc.add(FetchOrders(_currentCustomerId!));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _ordersBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFCEB007),
          elevation: 2,
          shadowColor: Color(0xFFCEB007).withOpacity(0.3),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/logo1.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 33),
              const Text(
                'My Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PlaceOrderScreen()),
                );
              },
            ),
          ],
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  return _buildBody(context, state);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Version - ${StringConstant.version}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 95, 91, 91),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset('assets/33.png', width: 100, height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, OrdersState state) {
    if (state is OrdersLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFCEB007)),
      );
    }
    if (state is OrdersError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final customerId =
                    _currentCustomerId ??
                    await _userService.getCurrentCustomerIdWithFallback();
                _ordersBloc.add(FetchOrders(customerId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEB007),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is OrdersEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t placed any orders yet',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }
    if (state is OrdersLoaded || state is OrdersRefreshing) {
      final orders = state is OrdersLoaded
          ? state.orders
          : (state as OrdersRefreshing).orders;
      final filteredOrders = state is OrdersLoaded
          ? state.filteredOrders
          : (state as OrdersRefreshing).filteredOrders;
      final currentFilter = state is OrdersLoaded
          ? state.currentFilter
          : (state as OrdersRefreshing).currentFilter;
      final customStartDate = state is OrdersLoaded
          ? state.customStartDate
          : (state as OrdersRefreshing).customStartDate;
      final customEndDate = state is OrdersLoaded
          ? state.customEndDate
          : (state as OrdersRefreshing).customEndDate;
      final isRefreshing = state is OrdersRefreshing;
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Filter:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          context,
                          'All',
                          DateFilter.all,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          'Today',
                          DateFilter.today,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          'This Week',
                          DateFilter.thisWeek,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          'This Month',
                          DateFilter.thisMonth,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          'Last 30 Days',
                          DateFilter.last30Days,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          context,
                          'Custom',
                          DateFilter.custom,
                          currentFilter,
                          customStartDate,
                          customEndDate,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (filteredOrders.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${filteredOrders.length} ${filteredOrders.length == 1 ? 'order' : 'orders'} found',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filter criteria',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      final customerId =
                          _currentCustomerId ??
                          await _userService.getCurrentCustomerIdWithFallback();
                      _ordersBloc.add(RefreshOrders(customerId));
                    },
                    color: const Color(0xFFCEB007),
                    child: Stack(
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final orderData = filteredOrders[index];
                            return _buildOrderCard(orderData);
                          },
                        ),
                        if (isRefreshing)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              child: const LinearProgressIndicator(
                                color: Color(0xFFCEB007),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildOrderCard(OrderData orderData) {
    final order = orderData.order;
    final items = orderData.items;
    final totalItems = items.length;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(order.createdDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        'Invoice: ${order.invoice}',
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        '$totalItems ${totalItems == 1 ? 'Item' : 'Items'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: InkWell(
                onTap: () => _showOrderDetails(orderData),
                child: const Icon(
                  Icons.visibility_outlined,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    DateFilter filter,
    DateFilter currentFilter,
    DateTime? customStartDate,
    DateTime? customEndDate,
  ) {
    final isSelected = currentFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterChanged(context, filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCEB007) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFCEB007) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          filter == DateFilter.custom &&
                  customStartDate != null &&
                  customEndDate != null
              ? '${_formatDateShort(customStartDate)} - ${_formatDateShort(customEndDate)}'
              : label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _onFilterChanged(BuildContext context, DateFilter filter) {
    if (filter == DateFilter.custom) {
      _showCustomDatePicker(context);
    } else {
      _ordersBloc.add(FilterOrders(filter: filter));
    }
  }

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFFCEB007)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _ordersBloc.add(
        FilterOrders(
          filter: DateFilter.custom,
          startDate: picked.start,
          endDate: picked.end,
        ),
      );
    } else {
      _ordersBloc.add(const FilterOrders(filter: DateFilter.all));
    }
  }

  void _showOrderDetails(OrderData orderData) {
    final order = orderData.order;
    final items = orderData.items;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Invoice: ${order.invoice}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  print(
                    'Debug - Item name: "${item.name}", Item ID: ${item.itemId}',
                  );
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item Name: ${item.name}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Item ID: ${item.itemId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Quantity: ${item.itemQuantity}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.itemQuantity == item.completedQuantity
                                  ? Colors.green
                                  : Color(0xFFCEB007),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.itemQuantity == item.completedQuantity
                                  ? 'Complete'
                                  : 'Pending',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Date:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _formatDate(order.createdDate),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Items:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${items.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _ordersBloc.close();
    super.dispose();
  }
}
