import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/verify_otp_service.dart';
import '../models/verify_otp_response.dart';
import '../../../../services/auth_service.dart';
import '../../../../features/auth/models/user.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpService verifyOtpService;
  final AuthService authService;
  
  VerifyOtpBloc({
    required this.verifyOtpService,
    required this.authService,
  }) : super(VerifyOtpState()) {
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
      if (response.success && response.data != null) {
        final userData = response.data!.data;
        final token = response.data!.token;
        
        // Create User object from UserData
        final user = User(
          userId: userData.mainId,
          mobileNumber: userData.mobile,
          name: userData.name,
          email: userData.email,
          userType: userData.type == 0 ? UserType.dealer : UserType.transporter,
          id: userData.id,
          isActive: !userData.isDeleted,
          createdAt: DateTime.parse(userData.createdDate),
          lastLoginAt: DateTime.now(),
        );
        
        // Store user data and token in auth service
        await authService.setToken(token);
        await authService.setUser(user);
        await authService.setStayLoggedIn(true);
        
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: response.message,
          userData: userData,
          token: token,
          refreshToken: response.data!.refresh,
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

