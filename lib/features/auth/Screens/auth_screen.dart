import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../dealer/bloc/dealer_auth_bloc.dart';
import '../dealer/bloc/dealer_auth_state.dart';
import '../dealer/bloc/dealer_auth_event.dart';
import '../transporter/bloc/transporter_auth_bloc.dart';
import '../transporter/bloc/transporter_auth_state.dart';
import '../transporter/bloc/transporter_auth_event.dart';
import '../../../utils/helpers.dart';
import '../../../utils/validators.dart';
import '../../../core/router/app_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Hardcoded credentials for testing/demo
  static const String hardcodedDealerId = "9021345655";
  static const String hardcodedDealerPassword = "Anu@1234";
  static const String hardcodedTransporterId = "";
  static const String hardcodedTransporterPassword = "";

  // Controllers for Dealer Login
  final TextEditingController _dealerMobileController = TextEditingController();
  final TextEditingController _dealerPasswordController =
      TextEditingController();

  // Controllers for Transporter Login
  final TextEditingController _transporterMobileController =
      TextEditingController();
  final TextEditingController _transporterPasswordController =
      TextEditingController();

  bool _isDealerPasswordVisible = false;
  bool _isTransporterPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dealerMobileController.dispose();
    _dealerPasswordController.dispose();
    _transporterMobileController.dispose();
    _transporterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return MultiBlocListener(
      listeners: [
        BlocListener<DealerAuthBloc, DealerAuthState>(
          listener: (context, state) {
            if (state.isAuthenticated && state.dealer != null) {
              Helpers.showSuccessSnackBar(context, 'Login successful!');
              context.go(AppRouter.dealerDashboard);
            } else if (state.error != null) {
              Helpers.showErrorSnackBar(context, state.error!);
            }
          },
        ),
        BlocListener<TransporterAuthBloc, TransporterAuthState>(
          listener: (context, state) {
            if (state.isAuthenticated && state.transporter != null) {
              Helpers.showSuccessSnackBar(context, 'Login successful!');
              context.go(AppRouter.transporterDashboard);
            } else if (state.error != null) {
              Helpers.showErrorSnackBar(context, state.error!);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // Header with logo/title
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    Image.asset(
                      'assets/logo.png',
                      // height: 120,
                      width: 150,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Color(0xFFCEB007),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEB007).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade600,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  tabs: const [
                    Tab(text: 'Dealer', height: 45),
                    Tab(text: 'Transporter', height: 45),
                  ],
                ),
              ),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildDealerLogin(), _buildTransporterLogin()],
                ),
              ),

              // Footer - Contact Support (only show when keyboard is not visible)
              // if (MediaQuery.of(context).viewInsets.bottom == 0)
              //   SafeArea(
              //     top: false,
              //     child: Container(
              //       padding: const EdgeInsets.all(20),
              //       child: TextButton(
              //         onPressed: () {
              //           _showContactSupport(context);
              //         },
              //         child: Text(
              //           'Contact Support',
              //           style: TextStyle(
              //             color: Color(0xFFCEB007),
              //             fontSize: 16,
              //             decoration: TextDecoration.underline,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              if (!isKeyboardVisible)
                SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      // Contact Support Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: TextButton(
                          onPressed: () {
                            _showContactSupport(context);
                          },
                          child: Text(
                            'Contact Support',
                            style: TextStyle(
                              color: Color.fromARGB(255, 206, 176, 7),
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // Logo/Image
                      Container(
                        height: screenHeight * 0.10, // Responsive height
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Image.asset(
                            'assets/33.png',
                            width: screenWidth * 0.5, // Responsive width
                            height: screenWidth * 0.5, // Keep aspect ratio
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.3,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[600],
                                  size: screenWidth * 0.1,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealerLogin() {
    return BlocBuilder<DealerAuthBloc, DealerAuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Mobile Number / Dealer ID Field
              TextFormField(
                controller: _dealerMobileController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / Dealer ID',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFCEB007), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _dealerPasswordController,
                obscureText: !_isDealerPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isDealerPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              _isDealerPasswordVisible =
                                  !_isDealerPasswordVisible;
                            });
                          },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFCEB007), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _showDealerForgotPassword(context);
                        },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFCEB007),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _handleDealerLogin();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCEB007),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              // Extra space to ensure content is scrollable when keyboard appears
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransporterLogin() {
    return BlocBuilder<TransporterAuthBloc, TransporterAuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Mobile Number / Transporter ID Field
              TextFormField(
                controller: _transporterMobileController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / Transporter ID',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFCEB007), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                controller: _transporterPasswordController,
                obscureText: !_isTransporterPasswordVisible,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isTransporterPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              _isTransporterPasswordVisible =
                                  !_isTransporterPasswordVisible;
                            });
                          },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFCEB007), width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _showTransporterForgotPassword(context);
                        },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFFCEB007),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _handleTransporterLogin();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCEB007),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              // Extra space to ensure content is scrollable when keyboard appears
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
            ],
          ),
        );
      },
    );
  }

  void _handleDealerLogin() {
    final mobileOrId = _dealerMobileController.text.trim();
    final password = _dealerPasswordController.text.trim();

    // Check for hardcoded credentials first
    if (mobileOrId == hardcodedDealerId &&
        password == hardcodedDealerPassword) {
      Helpers.showSuccessSnackBar(context, 'Login successful! ');
      context.go(AppRouter.dealerDashboard);
      return;
    }

    final mobileError = Validators.validateMobileOrId(mobileOrId);
    final passwordError = Validators.validatePassword(password);

    if (mobileError != null) {
      Helpers.showErrorSnackBar(context, mobileError);
      return;
    }

    if (passwordError != null) {
      Helpers.showErrorSnackBar(context, passwordError);
      return;
    }

    // If not hardcoded credentials, proceed with normal authentication
    context.read<DealerAuthBloc>().add(
      DealerLoginRequested(mobileNumberOrId: mobileOrId, password: password),
    );
  }

  void _handleTransporterLogin() {
    final mobileOrId = _transporterMobileController.text.trim();
    final password = _transporterPasswordController.text.trim();

    // Check for hardcoded credentials first
    if (mobileOrId == hardcodedTransporterId &&
        password == hardcodedTransporterPassword) {
      Helpers.showSuccessSnackBar(context, 'Login successful! ');
      context.go(AppRouter.transporterDashboard);
      return;
    }

    final mobileError = Validators.validateMobileOrId(mobileOrId);
    final passwordError = Validators.validatePassword(password);

    if (mobileError != null) {
      Helpers.showErrorSnackBar(context, mobileError);
      return;
    }

    if (passwordError != null) {
      Helpers.showErrorSnackBar(context, passwordError);
      return;
    }

    // If not hardcoded credentials, proceed with normal authentication
    context.read<TransporterAuthBloc>().add(
      TransporterLoginRequested(
        mobileNumberOrId: mobileOrId,
        password: password,
      ),
    );
  }

  void _showDealerForgotPassword(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Forgot Password - DEALER'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your mobile number or dealer ID to reset your password:',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number / Dealer ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final mobileOrId = controller.text.trim();
                if (mobileOrId.isNotEmpty) {
                  context.read<DealerAuthBloc>().add(
                    DealerForgotPasswordRequested(mobileNumberOrId: mobileOrId),
                  );
                  Navigator.of(dialogContext).pop();
                } else {
                  Helpers.showErrorSnackBar(
                    context,
                    'Please enter your mobile number or dealer ID',
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showTransporterForgotPassword(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Forgot Password - TRANSPORTER'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your mobile number or transporter ID to reset your password:',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number / Transporter ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final mobileOrId = controller.text.trim();
                if (mobileOrId.isNotEmpty) {
                  context.read<TransporterAuthBloc>().add(
                    TransporterForgotPasswordRequested(
                      mobileNumberOrId: mobileOrId,
                    ),
                  );
                  Navigator.of(dialogContext).pop();
                } else {
                  Helpers.showErrorSnackBar(
                    context,
                    'Please enter your mobile number or transporter ID',
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Need help? Contact our support team:'),
              SizedBox(height: 10),
              Text('Phone: +91-7907452174'),
              Text('Email: support@company.com'),
              // Text('Chat: Available 24/7'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
