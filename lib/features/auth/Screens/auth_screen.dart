import 'package:abm4customerapp/features/Contact_Support/screen/contact_us_screen.dart';
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
import '../../../core/di/injection.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';
import '../models/user.dart';
import '../../../constants/string_constants.dart';
import '../../OTP_authentication/Sent_otp/bloc/otp_bloc.dart';
import '../../OTP_authentication/Sent_otp/bloc/otp_event.dart';
import '../../OTP_authentication/Sent_otp/bloc/otp_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _dealerMobileController = TextEditingController();
  final TextEditingController _dealerPasswordController =
      TextEditingController();
  final TextEditingController _transporterMobileController =
      TextEditingController();
  final TextEditingController _transporterPasswordController =
      TextEditingController();
  late final OtpBloc _otpBloc;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _otpBloc = getIt<OtpBloc>();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final storageService = getIt<StorageService>();
      final stayLoggedIn = await storageService.getStayLoggedIn();
      if (stayLoggedIn) {
        final dealerCredentials = await storageService.getDealerCredentials();
        if (dealerCredentials['id'] != null &&
            dealerCredentials['password'] != null) {
          _dealerMobileController.text = dealerCredentials['id']!;
          _dealerPasswordController.text = dealerCredentials['password']!;
        }
        final transporterCredentials = await storageService
            .getTransporterCredentials();
        if (transporterCredentials['id'] != null &&
            transporterCredentials['password'] != null) {
          _transporterMobileController.text = transporterCredentials['id']!;
          _transporterPasswordController.text =
              transporterCredentials['password']!;
        }
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
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
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _otpBloc)],
      child: MultiBlocListener(
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
          BlocListener<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state.isSuccess && state.message != null) {
                Helpers.showSuccessSnackBar(context, state.message!);
                final phoneNumber = _tabController.index == 0
                    ? _dealerMobileController.text.trim()
                    : _transporterMobileController.text.trim();
                context.go('/verify-otp?phone=$phoneNumber');
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
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.asset('assets/logo1.png', width: 150),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 5),
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
                const SizedBox(height: 5),
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
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildDealerLogin(), _buildTransporterLogin()],
                  ),
                ),
                if (!isKeyboardVisible)
                  SafeArea(
                    top: false,
                    child: Column(
                      children: [
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
                        Container(
                          height: screenHeight * 0.10,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Image.asset(
                              'assets/33.png',
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.5,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(
                              'App Version - ${StringConstant.version}',
                              style: TextStyle(
                                color: Color.fromARGB(255, 95, 91, 91),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
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
      ),
    );
  }

  Widget _buildDealerLogin() {
    return BlocBuilder<DealerAuthBloc, DealerAuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = keyboardHeight > 0;
        return Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 25.0,
            right: 25.0,
            bottom: 65.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: isKeyboardVisible
                  ? 0
                  : MediaQuery.of(context).size.height * 0.3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: isKeyboardVisible
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _dealerMobileController,
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFCEB007),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _sendOTPForDealer();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCEB007),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransporterLogin() {
    return BlocBuilder<TransporterAuthBloc, TransporterAuthState>(
      builder: (context, state) {
        final isLoading = state.isLoading;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = keyboardHeight > 0;
        return Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 25.0,
            right: 25.0,
            bottom: 65.0,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: isKeyboardVisible
                  ? 0
                  : MediaQuery.of(context).size.height * 0.3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: isKeyboardVisible
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _transporterMobileController,
                  keyboardType: TextInputType.phone,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Color(0xFFCEB007),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          _sendOTPForTransporter();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCEB007),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                          'Send OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContactSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactUsScreen()),
    );
  }

  void _sendOTPForDealer() {
    final phoneNumber = _dealerMobileController.text.trim();
    if (phoneNumber.isEmpty) {
      Helpers.showErrorSnackBar(context, 'Please enter phone number');
      return;
    }
    if (phoneNumber.length != 10) {
      Helpers.showErrorSnackBar(
        context,
        'Please enter valid 10 digit phone number',
      );
      return;
    }
    _otpBloc.add(SendOtpRequested(phoneNumber: phoneNumber));
  }

  void _sendOTPForTransporter() {
    final phoneNumber = _transporterMobileController.text.trim();
    if (phoneNumber.isEmpty) {
      Helpers.showErrorSnackBar(context, 'Please enter phone number');
      return;
    }
    if (phoneNumber.length != 10) {
      Helpers.showErrorSnackBar(
        context,
        'Please enter valid 10 digit phone number',
      );
      return;
    }
    _otpBloc.add(SendOtpRequested(phoneNumber: phoneNumber));
  }
}
