import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }
  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final request = FeedbackRequest(
        referenceId: event.referenceId,
        referenceType: event.referenceType,
        companyId: event.companyId,
        name: event.name,
        customerId: event.customerId,
        email: event.email,
        customerFeedBack: event.customerFeedBack,
        rating: event.rating,
      );
      final response = await FeedbackService.submitFeedback(request);
      if (response.success) {
        emit(FeedbackSuccess(message: 'Thank you for your feedback!'));
      } else {
        emit(FeedbackError(error: response.message));
      }
    } catch (e) {
      emit(FeedbackError(error: 'Failed to submit feedback: $e'));
    }
  }
}

