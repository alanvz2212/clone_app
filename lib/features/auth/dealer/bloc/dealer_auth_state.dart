import 'package:equatable/equatable.dart';
import '../models/dealer.dart';

class DealerAuthState extends Equatable {
  final bool isAuthenticated;
  final Dealer? dealer;
  final String? token;
  final bool isLoading;
  final String? error;

  const DealerAuthState({
    this.isAuthenticated = false,
    this.dealer,
    this.token,
    this.isLoading = false,
    this.error,
  });

  DealerAuthState copyWith({
    bool? isAuthenticated,
    Dealer? dealer,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return DealerAuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      dealer: dealer ?? this.dealer,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, dealer, token, isLoading, error];
}