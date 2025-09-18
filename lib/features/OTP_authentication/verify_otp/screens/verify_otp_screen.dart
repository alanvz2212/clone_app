import 'package:clone/features/OTP_authentication/Sent_otp/screens/send_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/helpers.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../../../features/auth/dealer/bloc/dealer_auth_event.dart';
import '../bloc/verify_otp_bloc.dart';
import '../bloc/verify_otp_event.dart';
import '../bloc/verify_otp_state.dart';
class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyOtpScreen({
    super.key,
    required this.phoneNumber,
  });
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}
class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late final VerifyOtpBloc _verifyOtpBloc;
  @override
  void initState() {
    super.initState();
    _verifyOtpBloc = getIt<VerifyOtpBloc>();
  }
  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _verifyOtpBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _verifyOtpBloc,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCEB007),
        elevation: 2,
        shadowColor: const Color(0xFFCEB007).withOpacity(0.3),
        leading: IconButton(
  icon: const Icon(
    Icons.arrow_back_ios,
    color: Colors.white,
    size: 20,
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SendOtpScreen()),
    );
  },
),
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
             width: 80,
                        height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 33),
            const Text(
              'Verify OTP',
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
      body: BlocListener<VerifyOtpBloc, VerifyOtpState>(
        listener: (context, state) {
          if (state.isSuccess && state.message != null) {
            Helpers.showSuccessSnackBar(context, state.message!);
            if (state.userData?.type == 0) {
              context.read<DealerAuthBloc>().add(DealerAuthRestoreRequested());
              context.go('/dealer-dashboard');
            } else {
              context.go('/transporter-dashboard');
            }
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
                'Enter verification code',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFCEB007), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (index == 5 && value.isNotEmpty) {
                          _verifyOtp();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isLoading ? null : _verifyOtp,
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
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ],
          ),
        ),
        ),
      ),
    ));
  }
  void _verifyOtp() {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      Helpers.showErrorSnackBar(context, 'Please enter complete 6-digit OTP');
      return;
    }
    _verifyOtpBloc.add(VerifyOtpRequested(
      phoneNumber: widget.phoneNumber,
      otp: otp,
    ));
  }
  void _resendOtp() {
    Helpers.showSuccessSnackBar(context, 'OTP sent to ${widget.phoneNumber}');
  }
}

