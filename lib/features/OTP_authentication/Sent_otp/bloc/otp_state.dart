class OtpState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final String? error;

  OtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.error,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    String? error,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}