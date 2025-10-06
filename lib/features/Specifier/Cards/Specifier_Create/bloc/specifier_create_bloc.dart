import 'package:clone/features/Specifier/Cards/Specifier_Create/bloc/specifier_create_event.dart';
import 'package:clone/features/Specifier/Cards/Specifier_Create/bloc/specifier_create_state.dart';
import 'package:clone/features/Specifier/Cards/Specifier_Create/model/specifier_create_model.dart';
import 'package:clone/features/Specifier/Cards/Specifier_Create/services/specifier_create_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecifierCreateBloc
    extends Bloc<SpecifierCreateEvent, SpecifierCreateState> {
  SpecifierCreateBloc() : super(SpecifierCreateInitial()) {
    on<SubmitSpecifierCreateEvent>(_onsubmitSpecifierCreate);
  }

  Future<void> _onsubmitSpecifierCreate(
    SubmitSpecifierCreateEvent event,
    Emitter<SpecifierCreateState> emit,
  ) async {
    emit(SpecifierCreateLoading());
    try {
      final request = SpecifierCreateRequest(
        projectName: event.projectName,
        contactPerson: event.contactPerson,
        contactNumber: event.contactNumber,
        remarks: event.remarks,
        sheet: event.sheet,
      );
      final response = await SpecifierCreateService.submitSpecifierCreate(
        request,
      );

      if (response.success) {
        emit(SpecifierCreateSuccess(message: response.message));
      } else {
        emit(SpecifierCreateError(error: response.message));
      }
    } catch (e) {
      emit(
        SpecifierCreateError(
          error: 'Failed to submit Specifier create request: $e',
        ),
      );
    }
  }
}
