import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/router_extensions.dart';
import '../../../auth/transporter/bloc/transporter_auth_bloc.dart';
import '../../../auth/transporter/bloc/transporter_auth_event.dart';
import '../../../auth/transporter/bloc/transporter_auth_state.dart';

class DashboardTransporterScreen extends StatelessWidget {
  const DashboardTransporterScreen({super.key});

  AlertDialog _handleLogout(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Trigger logout event
            context.read<TransporterAuthBloc>().add(TransporterLogoutRequested());
            // Navigate to auth screen
            context.goToAuth();
          },
          child: const Text('Logout', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporter Dashboard'),
        backgroundColor: Color(0xFFCEB007),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _handleLogout(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(color: Color(0xFFCEB007)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Welcome Text
                BlocBuilder<TransporterAuthBloc, TransporterAuthState>(
                  builder: (context, state) {
                    final transporterName = state.transporter?.name ?? 'Transporter';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          transporterName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                        title: 'Date-wise Delivery Schedule',
                        // subtitle: 'Create new orders',
                        icon: Icons.delivery_dining,
                        color: Color(0xFFCEB007),
                        onTap: () => (context),
                        // subtitle: '',
                      ),
                      QuickAccessTile(
                        title: 'Delivery Button',
                        // subtitle: 'Track orders',
                        icon: Icons.smart_button_sharp,
                        color: Color(0xFFCEB007),
                        onTap: () => (context),
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
                  fontWeight: FontWeight.bold,
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
