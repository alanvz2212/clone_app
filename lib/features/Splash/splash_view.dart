import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';
import '../auth/models/user.dart';

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

    // Navigate to auth screen after splash duration
    _navigateToAuth();
  }

  void _navigateToAuth() async {
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      try {
        final authService = getIt<AuthService>();
        await authService.initializeAuth();
        final isAuthenticated = await authService.isLoggedIn();

        if (isAuthenticated) {
          // User is already logged in, determine which dashboard to show
          final currentUser = await authService.getCurrentUser();
          if (currentUser != null) {
            // Navigate based on user type
            if (currentUser.userType == UserType.dealer) {
              context.go(AppRouter.dealerDashboard);
            } else if (currentUser.userType == UserType.transporter) {
              context.go(AppRouter.transporterDashboard);
            } else {
              // Fallback to auth screen if user type is unknown
              _navigateToAuthScreen();
            }
          } else {
            // Token exists but no user data, go to auth screen
            _navigateToAuthScreen();
          }
        } else {
          // User is not authenticated, go to auth screen
          _navigateToAuthScreen();
        }
      } catch (e) {
        // Error occurred, go to auth screen
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
            // Get available height
            final availableHeight = constraints.maxHeight;
            final availableWidth = constraints.maxWidth;

            // Calculate responsive sizes
            final logoSize = (availableHeight * 0.35).clamp(200.0, 300.0);
            final footerImageSize = (availableHeight * 0.18).clamp(
              120.0,
              180.0,
            ); // Increased from 0.15 and min 100

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Top section with logo
                    Container(
                      height: availableHeight * 0.6,
                      child: Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
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

                    // Middle section with loader
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

                    // Bottom section with footer image
                    Container(
                      height: availableHeight * 0.3, // bigger footer space
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Image.asset(
                                'assets/33.png',
                                width: availableWidth * 0.5, // enlarged image
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
