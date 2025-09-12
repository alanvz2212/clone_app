import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/dues_service.dart';
import 'dues_event.dart';
import 'dues_state.dart';

class DuesBloc extends Bloc<DuesEvent, DuesState> {
  final DuesService _duesService;

  DuesBloc(this._duesService) : super(DuesInitial()) {
    on<LoadDues>(_onLoadDues);
    on<RefreshDues>(_onRefreshDues);
  }

  Future<void> _onLoadDues(LoadDues event, Emitter<DuesState> emit) async {
    emit(DuesLoading());
    try {
      // Use mock data for now - replace with actual API call when ready
      final dues = await _duesService.fetchMockDues();
      // final dues = await _duesService.fetchDues(event.request);
      emit(DuesLoaded(dues));
    } catch (e) {
      emit(DuesError(e.toString()));
    }
  }

  Future<void> _onRefreshDues(RefreshDues event, Emitter<DuesState> emit) async {
    try {
      // Use mock data for now - replace with actual API call when ready
      final dues = await _duesService.fetchMockDues();
      // final dues = await _duesService.fetchDues(event.request);
      emit(DuesLoaded(dues));
    } catch (e) {
      emit(DuesError(e.toString()));
    }
  }
}