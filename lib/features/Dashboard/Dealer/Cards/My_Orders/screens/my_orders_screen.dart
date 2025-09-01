import 'package:flutter/material.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../services/api_service.dart';
import '../models/order_models.dart';
import '../services/orders_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

enum DateFilter {
  all,
  today,
  thisWeek,
  thisMonth,
  last30Days,
  custom,
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late OrdersService _ordersService;
  List<OrderData> _orders = [];
  List<OrderData> _filteredOrders = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateFilter _selectedFilter = DateFilter.all;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    _ordersService = OrdersService(getIt<ApiService>());
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Using the customer ID from the API example (38590)
      final response = await _ordersService.getCustomerOrders(38590);

      setState(() {
        _orders = response.orders;
        _applyDateFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyDateFilter() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedFilter) {
      case DateFilter.all:
        _filteredOrders = List.from(_orders);
        break;
      case DateFilter.today:
        _filteredOrders = _orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAtSameMomentAs(today);
        }).toList();
        break;
      case DateFilter.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        _filteredOrders = _orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                 orderDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
        break;
      case DateFilter.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        _filteredOrders = _orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                 orderDate.isBefore(endOfMonth.add(const Duration(days: 1)));
        }).toList();
        break;
      case DateFilter.last30Days:
        final thirtyDaysAgo = today.subtract(const Duration(days: 30));
        _filteredOrders = _orders.where((orderData) {
          final orderDate = DateTime(
            orderData.order.createdDate.year,
            orderData.order.createdDate.month,
            orderData.order.createdDate.day,
          );
          return orderDate.isAfter(thirtyDaysAgo.subtract(const Duration(days: 1)));
        }).toList();
        break;
      case DateFilter.custom:
        if (_customStartDate != null && _customEndDate != null) {
          _filteredOrders = _orders.where((orderData) {
            final orderDate = DateTime(
              orderData.order.createdDate.year,
              orderData.order.createdDate.month,
              orderData.order.createdDate.day,
            );
            return orderDate.isAfter(_customStartDate!.subtract(const Duration(days: 1))) &&
                   orderDate.isBefore(_customEndDate!.add(const Duration(days: 1)));
          }).toList();
        } else {
          _filteredOrders = List.from(_orders);
        }
        break;
    }
  }

  void _onFilterChanged(DateFilter filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == DateFilter.custom) {
        _showCustomDatePicker();
      } else {
        _applyDateFilter();
      }
    });
  }

  Future<void> _showCustomDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFFCEB007),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _applyDateFilter();
      });
    } else {
      // If user cancels, revert to "All" filter
      setState(() {
        _selectedFilter = DateFilter.all;
        _applyDateFilter();
      });
    }
  }

  String _getFilterDisplayText() {
    switch (_selectedFilter) {
      case DateFilter.all:
        return 'All Orders';
      case DateFilter.today:
        return 'Today';
      case DateFilter.thisWeek:
        return 'This Week';
      case DateFilter.thisMonth:
        return 'This Month';
      case DateFilter.last30Days:
        return 'Last 30 Days';
      case DateFilter.custom:
        if (_customStartDate != null && _customEndDate != null) {
          return '${_formatDateShort(_customStartDate!)} - ${_formatDateShort(_customEndDate!)}';
        }
        return 'Custom Range';
    }
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFFCEB007),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFCEB007)),
      );
    }

    if (_errorMessage != null) {
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
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchOrders,
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

    if (_orders.isEmpty) {
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

    return Column(
      children: [
        // Filter Section
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
              Icon(
                Icons.filter_list,
                color: Colors.grey[600],
                size: 20,
              ),
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
                      _buildFilterChip('All', DateFilter.all),
                      const SizedBox(width: 8),
                      _buildFilterChip('Today', DateFilter.today),
                      const SizedBox(width: 8),
                      _buildFilterChip('This Week', DateFilter.thisWeek),
                      const SizedBox(width: 8),
                      _buildFilterChip('This Month', DateFilter.thisMonth),
                      const SizedBox(width: 8),
                      _buildFilterChip('Last 30 Days', DateFilter.last30Days),
                      const SizedBox(width: 8),
                      _buildFilterChip('Custom', DateFilter.custom),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Results Count
        if (_filteredOrders.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${_filteredOrders.length} ${_filteredOrders.length == 1 ? 'order' : 'orders'} found',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        
        // Orders List
        Expanded(
          child: _filteredOrders.isEmpty
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
                  onRefresh: _fetchOrders,
                  color: const Color(0xFFCEB007),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final orderData = _filteredOrders[index];
                      return _buildOrderCard(orderData);
                    },
                  ),
                ),
        ),
      ],
    );
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
            // Left side - Order info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Row(
                    children: [
                      // Icon(
                      //   Icons.calendar_today_outlined,
                      //   size: 16,
                      //   color: Colors.grey[600],
                      // ),
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

                  // Invoice Number
                  Row(
                    children: [
                      // Icon(
                      //   Icons.receipt_outlined,
                      //   size: 16,
                      //   color: Colors.grey[600],
                      // ),
                      const SizedBox(width: 8),
                      Text(
                        'Invoice: ${order.invoice}',
                        style: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Number of Items
                  Row(
                    children: [
                      // Icon(
                      //   Icons.inventory_2_outlined,
                      //   size: 16,
                      //   color: Colors.grey[600],
                      // ),
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
            // InkWell(
            //   onTap: () => _showOrderDetails(orderData),
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(border: Border.all(width: 1)),
            //     child: const Icon(Icons.visibility_outlined, size: 20),
            //   ),
            // ),
            InkWell(
              onTap: () => _showOrderDetails(orderData),
              child: const Icon(Icons.visibility_outlined, size: 20),
            ),

            // Right side - View button
            // InkWell(
            //   onTap: () => _showOrderDetails(orderData),
            //   borderRadius: BorderRadius.circular(20),
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFCEB007).withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(20),
            //       border: Border.all(
            //         color: const Color(0xFFCEB007),
            //         width: 1,
            //       ),
            //     ),
            //     child: const Icon(
            //       Icons.visibility_outlined,
            //       // color: Color(0xFFCEB007),
            //       size: 20,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
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
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Details',
                          style: const TextStyle(
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

            // Items list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Item icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            // decoration: BoxDecoration(
                            //   color: const Color(0xFFCEB007).withOpacity(0.1),
                            //   borderRadius: BorderRadius.circular(8),
                            // ),
                            // child: const Icon(
                            //   Icons.inventory_2_outlined,
                            //   color: Color(0xFFCEB007),
                            //   size: 20,
                            // ),
                          ),
                          const SizedBox(width: 12),

                          // Item details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Item ID: ${item.itemId}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
                                    // const SizedBox(width: 16),
                                    // Text(
                                    //   'Completed: ${item.completedQuantity}',
                                    //   style: TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.grey[600],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.itemQuantity == item.completedQuantity
                                  ? Colors.white
                                  : Colors.black,
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

            // Footer with order info
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
                  // if (order.notes != null && order.notes!.isNotEmpty) ...[
                  //   const SizedBox(height: 8),
                  //   // Text(
                  //   //   'Notes:',
                  //   //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  //   // ),
                  //   const SizedBox(height: 4),
                  //   Text(order.notes!, style: const TextStyle(fontSize: 12)),
                  // ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool isCompleted) {
    return isCompleted ? Colors.green : Colors.orange;
  }

  Widget _buildFilterChip(String label, DateFilter filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () => _onFilterChanged(filter),
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
          filter == DateFilter.custom && _customStartDate != null && _customEndDate != null
              ? '${_formatDateShort(_customStartDate!)} - ${_formatDateShort(_customEndDate!)}'
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
