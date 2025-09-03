import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/dealer_auth_model.dart';
import '../repositories/dealer_auth_repository.dart';
import 'dealer_auth_event.dart';
import 'dealer_auth_state.dart';
import '../../../../services/auth_service.dart';

class DealerAuthBloc extends Bloc<DealerAuthEvent, DealerAuthState> {
  final DealerAuthRepository _repository;
  final AuthService _authService;

  DealerAuthBloc({
    required DealerAuthRepository repository,
    required AuthService authService,
  })  : _repository = repository,
        _authService = authService,
        super(const DealerAuthState()) {
    on<DealerLoginRequested>(_onLoginRequested);
    on<DealerLogoutRequested>(_onLogoutRequested);
    on<DealerForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onLoginRequested(
    DealerLoginRequested event,
    Emitter<DealerAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final request = DealerLoginRequest(
        mobileNumberOrId: event.mobileNumberOrId,
        password: event.password,
      );

      final response = await _repository.login(request);

      if (response.success &&
          response.dealer != null &&
          response.token != null) {
        emit(
          state.copyWith(
            isAuthenticated: true,
            dealer: response.dealer,
            token: response.token,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: response.error ?? 'Login failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Login failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    DealerLogoutRequested event,
    Emitter<DealerAuthState> emit,
  ) async {
    try {
      // Use AuthService to properly clear all authentication data
      await _authService.logout();
      
      // Clear bloc state
      emit(const DealerAuthState());
    } catch (e) {
      // Even if logout API fails, clear local state
      emit(const DealerAuthState());
    }
  }

  Future<void> _onForgotPasswordRequested(
    DealerForgotPasswordRequested event,
    Emitter<DealerAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final request = DealerForgotPasswordRequest(
        mobileNumberOrId: event.mobileNumberOrId,
      );

      final success = await _repository.forgotPassword(request);

      if (success) {
        emit(state.copyWith(isLoading: false, error: null));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Failed to send password reset request',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Password reset failed: ${e.toString()}',
        ),
      );
    }
  }
}
