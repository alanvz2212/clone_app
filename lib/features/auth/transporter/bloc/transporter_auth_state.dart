import 'package:equatable/equatable.dart';
import '../models/transporter.dart';
class TransporterAuthState extends Equatable {
  final bool isAuthenticated;
  final Transporter? transporter;
  final String? token;
  final bool isLoading;
  final String? error;
  const TransporterAuthState({
    this.isAuthenticated = false,
    this.transporter,
    this.token,
    this.isLoading = false,
    this.error,
  });
  TransporterAuthState copyWith({
    bool? isAuthenticated,
    Transporter? transporter,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return TransporterAuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      transporter: transporter ?? this.transporter,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
  @override
  List<Object?> get props => [isAuthenticated, transporter, token, isLoading, error];
}

