import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

extension AppRouterExtension on BuildContext {
  // Navigation methods
  void goToSplash() => go(AppRouter.splash);
  void goToAuth() => go(AppRouter.auth);
  void goToDealerDashboard() => go(AppRouter.dealerDashboard);
  void goToTransporterDashboard() => go(AppRouter.transporterDashboard);

  // Push methods (for navigation stack)
  void pushAuth() => push(AppRouter.auth);
  void pushDealerDashboard() => push(AppRouter.dealerDashboard);
  void pushTransporterDashboard() => push(AppRouter.transporterDashboard);

  // Replace methods
  void replaceWithAuth() => pushReplacement(AppRouter.auth);
  void replaceWithDealerDashboard() =>
      pushReplacement(AppRouter.dealerDashboard);
  void replaceWithTransporterDashboard() =>
      pushReplacement(AppRouter.transporterDashboard);
}
