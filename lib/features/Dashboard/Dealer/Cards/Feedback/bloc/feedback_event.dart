import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class SubmitFeedbackEvent extends FeedbackEvent {
  final int referenceId;
  final String referenceType;
  final int companyId;
  final String name;
  final int customerId;
  final String email;
  final String customerFeedBack;
  final int rating;

  const SubmitFeedbackEvent({
    required this.referenceId,
    required this.referenceType,
    required this.companyId,
    required this.name,
    required this.customerId,
    required this.email,
    required this.customerFeedBack,
    required this.rating,
  });

  @override
  List<Object> get props => [
        referenceId,
        referenceType,
        companyId,
        name,
        customerId,
        email,
        customerFeedBack,
        rating,
      ];
}