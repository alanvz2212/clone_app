import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/verify_otp_service.dart';
import '../models/verify_otp_response.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpService verifyOtpService;

  VerifyOtpBloc({required this.verifyOtpService}) : super(VerifyOtpState()) {
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await verifyOtpService.verifyOtp(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      );
      
      if (response.success) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: response.message,
          userData: response.data?.data,
          token: response.data?.token,
          refreshToken: response.data?.refresh,
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