import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../core/di/injection.dart';
import '../../core/router/app_router.dart';

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
      // Check authentication status
      try {
        final authService = getIt<AuthService>();
        await authService.initializeAuth();
        final isAuthenticated = await authService.isLoggedIn();

        if (isAuthenticated) {
          // Navigate to home screen (to be implemented)
          // For now, we'll navigate to auth screen
          _navigateToAuthScreen();
        } else {
          _navigateToAuthScreen();
        }
      } catch (e) {
        // If there's an error, navigate to auth screen
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top spacing
            const Spacer(flex: 2),

            // ABM4 Logo (centered)
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Center(child: Image.asset('assets/logo.png')),
                    const SizedBox(height: 24),

                    // Tagline placeholder
                    const Text(
                      'TBD',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Middle spacing
            const Spacer(flex: 3),

            // Loader animation at bottom
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // const Text(
                    //   'Loading...',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey,
                    //     fontWeight: FontWeight.w300,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
