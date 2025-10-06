import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../auth/models/user.dart';
import '../../constants/string_constants.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _navigateToAuth();
  }
  void _navigateToAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      try {
        final authService = getIt<AuthService>();
        await authService.initializeAuth();
        final isAuthenticated = await authService.isLoggedIn();
        if (isAuthenticated) {
          final currentUser = await authService.getCurrentUser();
          if (currentUser != null) {
            if (currentUser.userType == UserType.dealer) {
              context.go(AppRouter.dealerDashboard);
            } else if (currentUser.userType == UserType.transporter) {
              context.go(AppRouter.transporterDashboard);
            } else {
              _navigateToAuthScreen();
            }
          } else {
            _navigateToAuthScreen();
          }
        } else {
          _navigateToAuthScreen();
        }
      } catch (e) {
        _navigateToAuthScreen();
      }
    }
  }
  void _navigateToAuthScreen() {
    context.go(AppRouter.auth);
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final availableWidth = constraints.maxWidth;
            final logoSize = (availableHeight * 0.35).clamp(200.0, 300.0);
            final footerImageSize = (availableHeight * 0.18).clamp(
              120.0,
              180.0,
            );
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: availableHeight * 0.6,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo1.png',
                                width: logoSize,
                                height: logoSize,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: logoSize,
                                    height: logoSize,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: availableHeight * 0.2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 35,
                              height: 35,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFCEB007),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: availableHeight * 0.3,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Image.asset(
                                'assets/33.png',
                                width: availableWidth * 0.5,
                                height: availableWidth * 0.5,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: availableWidth * 0.7,
                                    height: availableWidth * 0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'App Version - ${StringConstant.version}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 95, 91, 91),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

