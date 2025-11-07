import 'package:clone/constants/string_constants.dart';
import 'package:clone/core/router/router_extensions.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Scheme_specifier/screen/scheme_specifier.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Specifier_Create/screens/specifier_create_screen.dart';
import 'package:clone/features/auth/dealer/bloc/dealer_auth_bloc.dart';
import 'package:clone/features/auth/dealer/bloc/dealer_auth_event.dart';
import 'package:clone/features/auth/dealer/bloc/dealer_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecifierDashboardScreen extends StatefulWidget {
  const SpecifierDashboardScreen({super.key});

  @override
  State<SpecifierDashboardScreen> createState() =>
      _SpecifierDashboardScreenState();
}

class _SpecifierDashboardScreenState extends State<SpecifierDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DealerAuthBloc>().add(DealerAuthRestoreRequested());
    // });
  }

  AlertDialog __handleLogout(BuildContext context) {
    return (AlertDialog(
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
            context.read<DealerAuthBloc>().add(DealerLogoutRequested());
            context.goToAuth();
          },
          child: const Text('Logout', style: TextStyle(color: Colors.black)),
        ),
      ],
    ));
  }

  void _navigateToSpecification(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SpecifierCreateScreen()),
    );
  }

  void _navigateToSpecifierScheme(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SchemeSpecifier()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              width: 70,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20),
            const Text(
              'Specifier Dashboard',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFCEB007),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => __handleLogout(context),
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
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
                BlocBuilder<DealerAuthBloc, DealerAuthState>(
                  builder: (context, state) {
                    print('=== Dashboard BlocBuilder Debug ===');
                    print('State: $state');
                    print('Is Authenticated: ${state.isAuthenticated}');
                    print('Dealer: ${state.dealer}');
                    print('Dealer Name: ${state.dealer?.name}');
                    print('Dealer Name: ${state.dealer?.mobile}');
                    print('Dealer Email: ${state.dealer?.email}');
                    print('Dealer ID: ${state.dealer?.id}');
                    print('Token: ${state.token != null ? "Present" : "Null"}');
                    print('=== End Dashboard Debug ===');

                    String dealerName = 'Dealer';
                    if (state.dealer?.name != null &&
                        state.dealer!.name.isNotEmpty) {
                      dealerName = state.dealer!.name;
                    } else if (state.isAuthenticated) {
                      dealerName = 'User';
                    }

                    String dealerMobile = 'Dealer';
                    if (state.dealer?.mobile != null &&
                        state.dealer!.mobile.isNotEmpty) {
                      dealerMobile = state.dealer!.mobile;
                    } else if (state.isAuthenticated) {
                      dealerMobile = 'User';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,\n$dealerName,  $dealerMobile',
                          style: TextStyle(
                            color: Color.fromARGB(255, 95, 91, 91),
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                        if (state.dealer == null && state.isAuthenticated)
                          Text(
                            'Debug: Authenticated but no dealer data',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                      ],
                    );
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notifications clicked'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Color.fromARGB(255, 95, 91, 91),
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                    children: [
                      QuickAccessTile(
                        title: 'Create Specification',
                        imagePath: 'assets/dashboard/my_cart.png',
                        onTap: () => _navigateToSpecification(context),
                      ),
                      QuickAccessTile(
                        title: 'Scheme',
                        imagePath: 'assets/dashboard/my_cart.png',
                        onTap: () => _navigateToSpecifierScheme(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
    );
  }
}

class QuickAccessTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final String? badge;
  final VoidCallback onTap;
  const QuickAccessTile({
    super.key,
    required this.title,
    required this.imagePath,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          imagePath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (badge != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
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
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              const Spacer(),
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
