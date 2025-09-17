import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
extension AppRouterExtension on BuildContext {
  void goToSplash() => go(AppRouter.splash);
  void goToAuth() => go(AppRouter.auth);
  void goToDealerDashboard() => go(AppRouter.dealerDashboard);
  void goToTransporterDashboard() => go(AppRouter.transporterDashboard);
  void pushAuth() => push(AppRouter.auth);
  void pushDealerDashboard() => push(AppRouter.dealerDashboard);
  void pushTransporterDashboard() => push(AppRouter.transporterDashboard);
  void replaceWithAuth() => pushReplacement(AppRouter.auth);
  void replaceWithDealerDashboard() =>
      pushReplacement(AppRouter.dealerDashboard);
  void replaceWithTransporterDashboard() =>
      pushReplacement(AppRouter.transporterDashboard);
}

