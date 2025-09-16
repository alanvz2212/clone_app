import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';
import '../../../../utils/helpers.dart';
import '../../../../utils/validators.dart';
import '../../../../core/di/injection.dart';

class SendOtpScreen extends StatefulWidget {
  const SendOtpScreen({super.key});

  @override
  State<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends State<SendOtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  late final OtpBloc _otpBloc;

  @override
  void initState() {
    super.initState();
    _otpBloc = getIt<OtpBloc>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _otpBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Color(0xFFCEB007),
                  elevation: 2,
                  shadowColor: Color(0xFFCEB007).withOpacity(0.3),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      context.go('/auth');
                    },
                  ),
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/logo1.png',
                        width: 70,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 33),
                      const Text(
                        'Phone Verification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  titleSpacing: 0,
                ),
        body: BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state.isSuccess && state.message != null) {
              Helpers.showSuccessSnackBar(context, state.message!);
              final phoneNumber = _phoneController.text.trim();
              context.go('/verify-otp?phone=$phoneNumber');
            } else if (state.error != null) {
              Helpers.showErrorSnackBar(context, state.error!);
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  
                  Text(
                    'Enter your phone number',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // const SizedBox(height: 10),
                  
                  // Text(
                  //   'We will send you an OTP to reset your password',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.grey.shade600,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  
                  const SizedBox(height: 40),
                  
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFCEB007), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isLoading ? null : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCEB007),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendOtp() {
    final phoneNumber = _phoneController.text.trim();
    
    if (phoneNumber.isEmpty) {
      Helpers.showErrorSnackBar(context, 'Please enter phone number');
      return;
    }
    
    if (phoneNumber.length != 10) {
      Helpers.showErrorSnackBar(context, 'Please enter valid 10 digit phone number');
      return;
    }

    _otpBloc.add(SendOtpRequested(phoneNumber: phoneNumber));
  }
}