import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/contact_us_model.dart';
import '../services/contact_us_service.dart';
import 'contact_us_event.dart';
import 'contact_us_state.dart';

class ContactUsBloc extends Bloc<ContactUsEvent, ContactUsState> {
  ContactUsBloc() : super(ContactUsInitial()) {
    on<SubmitContactUsEvent>(_onSubmitContactUs);
  }

  Future<void> _onSubmitContactUs(
    SubmitContactUsEvent event,
    Emitter<ContactUsState> emit,
  ) async {
    emit(ContactUsLoading());
    try {
      final request = ContactUsRequest(
        whatsappNumber: event.whatsappNumber,
        contactNumber: event.contactNumber,
        companyName: event.companyName,
        companyAddress: event.companyAddress,
        companyGST: event.companyGST,
      );

      final response = await ContactUsService.submitContactUs(
        request,
        event.gstCertificateFile,
      );

      if (response.success) {
        emit(ContactUsSuccess(message: 'Thank you for contacting us!'));
      } else {
        emit(ContactUsError(error: response.message));
      }
    } catch (e) {
      emit(ContactUsError(error: 'Failed to submit contact request: $e'));
    }
  }
}
