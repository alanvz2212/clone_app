import 'package:flutter/material.dart';
import '../models/sales_order_model.dart';
import '../services/sales_order_service.dart';
import 'package:clone/constants/string_constants.dart';

class NewMyOrdersScreen extends StatefulWidget {
  final int customerId;

  const NewMyOrdersScreen({Key? key, required this.customerId})
    : super(key: key);

  @override
  State<NewMyOrdersScreen> createState() => _NewMyOrdersScreenState();
}

class _NewMyOrdersScreenState extends State<NewMyOrdersScreen> {
  List<SalesOrder> salesOrders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSalesOrders();
  }

  Future<void> fetchSalesOrders() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final orders = await SalesOrderService.getCustomerSalesOrders(
        widget.customerId,
      );

      setState(() {
        salesOrders = orders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCEB007),
        elevation: 2,
        shadowColor: Color(0xFFCEB007).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              width: 70,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 30),
            const Text(
              'My Orders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Container(color: Colors.grey[50], child: _buildBody()),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
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
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading orders',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchSalesOrders,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (salesOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchSalesOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: salesOrders.length,
        itemBuilder: (context, index) {
          final order = salesOrders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(SalesOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.invoice,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.orderstatus),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(order.invoiceDate),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${order.id}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  '\₹ ${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    // fontWeight: FontWeight.bold,
                    // color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    // Always show Pending chip in this module
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // decoration: BoxDecoration(
      //   color: Colors.blue[100],
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: Text(
        'Pending',
        style: TextStyle(
          fontSize: 12,
          // color: Colors.blue[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
