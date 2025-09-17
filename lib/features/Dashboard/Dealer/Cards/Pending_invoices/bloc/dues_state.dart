import 'package:equatable/equatable.dart';
import '../models/dues_model.dart';
abstract class DuesState extends Equatable {
  const DuesState();
  @override
  List<Object> get props => [];
}
class DuesInitial extends DuesState {}
class DuesLoading extends DuesState {}
class DuesLoaded extends DuesState {
  final List<DuesModel> dues;
  const DuesLoaded(this.dues);
  @override
  List<Object> get props => [dues];
}
class DuesError extends DuesState {
  final String message;
  const DuesError(this.message);
  @override
  List<Object> get props => [message];
}

