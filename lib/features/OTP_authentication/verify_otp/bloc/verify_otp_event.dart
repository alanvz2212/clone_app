abstract class VerifyOtpEvent {}
class VerifyOtpRequested extends VerifyOtpEvent {
  final String phoneNumber;
  final String otp;
  VerifyOtpRequested({
    required this.phoneNumber,
    required this.otp,
  });
}

