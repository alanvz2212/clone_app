import 'package:equatable/equatable.dart';
import '../models/dues_model.dart';

abstract class DuesEvent extends Equatable {
  const DuesEvent();

  @override
  List<Object> get props => [];
}

class LoadDues extends DuesEvent {
  final DuesRequest request;

  const LoadDues(this.request);

  @override
  List<Object> get props => [request];
}

class RefreshDues extends DuesEvent {
  final DuesRequest request;

  const RefreshDues(this.request);

  @override
  List<Object> get props => [request];
}