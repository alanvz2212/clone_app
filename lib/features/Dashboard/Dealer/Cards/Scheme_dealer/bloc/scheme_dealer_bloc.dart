import 'package:clone/features/Dashboard/Dealer/Cards/Scheme_dealer/bloc/scheme_event_bloc.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Scheme_dealer/bloc/scheme_state_bloc.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Scheme_dealer/models/scheme_dealer_model.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Scheme_dealer/service/scheme_dealer_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SchemeDealerBloc extends Bloc<SchemeDealerEvent, SchemeDealerState> {
  final SchemeDealerService _service;
  final Logger _logger = Logger();

  SchemeDealerBloc({SchemeDealerService? service})
    : _service = service ?? SchemeDealerService(),
      super(SchemeInitial()) {
    on<LoadSchemes>(_onLoadSchemes);
    on<RefreshSchemes>(_onRefreshSchemes);
    on<RetryLoadSchemes>(_onRetryLoadSchemes);
  }

  Future<void> _onLoadSchemes(
    LoadSchemes event,
    Emitter<SchemeDealerState> emit,
  ) async {
    try {
      emit(SchemeLoading());
      _logger.i('Loading schemes for user: ${event.userId}');

      final schemes = await _service.getDealerSchemes(event.userId);

      if (schemes.isEmpty) {
        emit(SchemeEmpty(userId: event.userId));
      } else {
        emit(SchemeLoaded(schemes: schemes, userId: event.userId));
      }

      _logger.i('Successfully loaded ${schemes.length} schemes');
    } catch (error) {
      _logger.e('Error loading schemes: $error');
      emit(SchemeError(message: _getErrorMessage(error), userId: event.userId));
    }
  }

  Future<void> _onRefreshSchemes(
    RefreshSchemes event,
    Emitter<SchemeDealerState> emit,
  ) async {
    try {
      if (state is SchemeLoaded) {
        final currentState = state as SchemeLoaded;
        emit(SchemeRefreshing(currentSchemes: currentState.schemes));
      } else {
        emit(SchemeLoading());
      }

      _logger.i('Refreshing schemes for user: ${event.userId}');

      final schemes = await _service.getDealerSchemes(event.userId);

      if (schemes.isEmpty) {
        emit(SchemeEmpty(userId: event.userId));
      } else {
        emit(SchemeLoaded(schemes: schemes, userId: event.userId));
      }

      _logger.i('Successfully refreshed ${schemes.length} schemes');
    } catch (error) {
      _logger.e('Error refreshing schemes: $error');
      emit(SchemeError(message: _getErrorMessage(error), userId: event.userId));
    }
  }

  Future<void> _onRetryLoadSchemes(
    RetryLoadSchemes event,
    Emitter<SchemeDealerState> emit,
  ) async {
    _logger.i('Retrying to load schemes for user: ${event.userId}');
    add(LoadSchemes(userId: event.userId));
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Request timeout. Please try again.';
    } else if (error.toString().contains('FormatException')) {
      return 'Invalid data format received from server.';
    } else if (error.toString().contains('401')) {
      return 'Authentication failed. Please login again.';
    } else if (error.toString().contains('403')) {
      return 'Access denied. You don\'t have permission to view this data.';
    } else if (error.toString().contains('404')) {
      return 'No schemes found for this user.';
    } else if (error.toString().contains('500')) {
      return 'Server error. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
