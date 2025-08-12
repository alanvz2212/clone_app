import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/Screen/Place_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/string_constants.dart';
import '../../../auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../../auth/dealer/bloc/dealer_auth_state.dart';

class DashboardDealerScreen extends StatelessWidget {
  const DashboardDealerScreen({super.key});

  void _navigateToMyOrders(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to My Orders')));
  }

  void _navigateToNewArrivals(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to New Arrivals')));
  }

  void _navigateToInventory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Inventory & Pricing')),
    );
  }

  void _navigateToPromotions(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Promotions')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icon(CupertinoIcons.back),
            // const SizedBox(width: 8),
            Image.asset(
              'assets/logo.png', // Replace with your image path
              width: 70,
              height: 35,
              fit: BoxFit.contain,
            ),
            // const SizedBox(width: 8),
            const SizedBox(width: 35),
            const Text(
              'Dealer Dashboard',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Top Bar with Welcome and Notification
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[700],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Welcome Text
                BlocBuilder<DealerAuthBloc, DealerAuthState>(
                  builder: (context, state) {
                    print('=== Dashboard BlocBuilder Debug ===');
                    print('State: $state');
                    print('Is Authenticated: ${state.isAuthenticated}');
                    print('Dealer: ${state.dealer}');
                    print('Dealer Name: ${state.dealer?.name}');
                    print('=== End Dashboard Debug ===');

                    final dealerName = state.dealer?.name ?? 'Dealer';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,\n$dealerName',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Notification Icon
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle notification tap
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifications clicked'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    // Notification badge
                  ],
                ),
              ],
            ),
          ),

          // Quick Access Tiles Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Access',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Grid Layout for Tiles
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0, // Square tiles
                    children: [
                      QuickAccessTile(
                        title: 'Place Order',
                        // subtitle: 'Create new orders',
                        icon: Icons.add_shopping_cart,
                        color: Colors.blue,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PlaceOrderScreen(),
                          ),
                        ),
                        // subtitle: '',
                      ),
                      QuickAccessTile(
                        title: 'My Orders',
                        // subtitle: 'Track orders',
                        icon: Icons.receipt_long,
                        color: Colors.blue,
                        onTap: () => _navigateToMyOrders(context),
                      ),
                      QuickAccessTile(
                        title: 'New Arrivals',

                        icon: Icons.fiber_new,
                        color: Colors.blue,
                        onTap: () => _navigateToNewArrivals(context),
                      ),
                      QuickAccessTile(
                        title: 'Inventory & Pricing',
                        icon: Icons.inventory_2,
                        color: Colors.blue,
                        onTap: () => _navigateToInventory(context),
                      ),
                      QuickAccessTile(
                        title: 'Promotions',
                        // subtitle: '',
                        icon: Icons.local_offer,
                        color: Colors.blue,
                        onTap: () => _navigateToPromotions(context),
                      ),
                    ],
                  ),

                  // Optional: Add more sections below
                  const SizedBox(height: 24),
                  // You can add more widgets here like:
                  // - Recent Orders
                  // - Sales Summary
                  // - Quick Stats
                ],
              ),
            ),
          ),

          // App Version at the bottom
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Version - ${StringConstant.version}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAccessTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

  const QuickAccessTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              const Spacer(),

              // Arrow Icon
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
