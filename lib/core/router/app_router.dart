import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/Splash/splash_view.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/Dashboard/Dealer/Screens/dashboard_dealer_screen.dart';
import '../../features/Dashboard/Transporter/Screens/dashboard_transporter_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String dealerDashboard = '/dealer-dashboard';
  static const String transporterDashboard = '/transporter-dashboard';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: dealerDashboard,
        name: 'dealer-dashboard',
        builder: (context, state) => const DashboardDealerScreen(),
      ),
      GoRoute(
        path: transporterDashboard,
        name: 'transporter-dashboard',
        builder: (context, state) => const DashboardTransporterScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
