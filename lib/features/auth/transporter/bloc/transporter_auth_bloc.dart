import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transporter_auth_model.dart';
import '../repositories/transporter_auth_repository.dart';
import 'transporter_auth_event.dart';
import 'transporter_auth_state.dart';
import '../../../../services/auth_service.dart';

class TransporterAuthBloc
    extends Bloc<TransporterAuthEvent, TransporterAuthState> {
  final TransporterAuthRepository _repository;
  final AuthService _authService;

  TransporterAuthBloc({
    required TransporterAuthRepository repository,
    required AuthService authService,
  })  : _repository = repository,
        _authService = authService,
        super(const TransporterAuthState()) {
    on<TransporterLoginRequested>(_onLoginRequested);
    on<TransporterLogoutRequested>(_onLogoutRequested);
    on<TransporterForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onLoginRequested(
    TransporterLoginRequested event,
    Emitter<TransporterAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final request = TransporterLoginRequest(
        mobileNumberOrId: event.mobileNumberOrId,
        password: event.password,
      );

      final response = await _repository.login(request);

      if (response.success &&
          response.transporter != null &&
          response.token != null) {
        emit(
          state.copyWith(
            isAuthenticated: true,
            transporter: response.transporter,
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
    TransporterLogoutRequested event,
    Emitter<TransporterAuthState> emit,
  ) async {
    try {
      // Use AuthService to properly clear all authentication data
      await _authService.logout();
      
      // Clear bloc state
      emit(const TransporterAuthState());
    } catch (e) {
      // Even if logout API fails, clear local state
      emit(const TransporterAuthState());
    }
  }

  Future<void> _onForgotPasswordRequested(
    TransporterForgotPasswordRequested event,
    Emitter<TransporterAuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final request = TransporterForgotPasswordRequest(
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
