abstract class OtpEvent {}

class SendOtpRequested extends OtpEvent {
  final String phoneNumber;

  SendOtpRequested({required this.phoneNumber});
}