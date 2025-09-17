import 'package:equatable/equatable.dart';
abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override
  List<Object> get props => [];
}
class FeedbackInitial extends FeedbackState {}
class FeedbackLoading extends FeedbackState {}
class FeedbackSuccess extends FeedbackState {
  final String message;
  const FeedbackSuccess({required this.message});
  @override
  List<Object> get props => [message];
}
class FeedbackError extends FeedbackState {
  final String error;
  const FeedbackError({required this.error});
  @override
  List<Object> get props => [error];
}

