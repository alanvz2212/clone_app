import 'package:flutter/material.dart';
import 'my_orders_widget.dart';
import 'screens/my_orders_screen.dart';

// Example of how to use the MyOrders widget in your app

class ExampleDashboard extends StatelessWidget {
  final int loggedInCustomerId = 40807; // Replace with dynamic customer ID

  const ExampleDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Other dashboard cards...
            
            // My Orders Widget
            MyOrdersWidget(customerId: loggedInCustomerId),
            
            // Other dashboard cards...
          ],
        ),
      ),
    );
  }
}

// Alternative: Direct navigation to orders screen
class DirectNavigationExample extends StatelessWidget {
  final int loggedInCustomerId = 40807; // Replace with dynamic customer ID

  const DirectNavigationExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewMyOrdersScreen(customerId: loggedInCustomerId),
              ),
            );
          },
          child: const Text('View My Orders'),
        ),
      ),
    );
  }
}