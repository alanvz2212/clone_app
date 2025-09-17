import '../models/verify_otp_response.dart';
class VerifyOtpState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final String? error;
  final UserData? userData;
  final String? token;
  final String? refreshToken;
  VerifyOtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.error,
    this.userData,
    this.token,
    this.refreshToken,
  });
  VerifyOtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    String? error,
    UserData? userData,
    String? token,
    String? refreshToken,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      error: error ?? this.error,
      userData: userData ?? this.userData,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

