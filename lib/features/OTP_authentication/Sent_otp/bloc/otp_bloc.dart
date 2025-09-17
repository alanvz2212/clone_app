import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/otp_service.dart';
import 'otp_event.dart';
import 'otp_state.dart';
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpService otpService;
  OtpBloc({required this.otpService}) : super(OtpState()) {
    on<SendOtpRequested>(_onSendOtpRequested);
  }
  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await otpService.sendOtp(event.phoneNumber);
      if (response.success) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: response.message,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: response.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}

