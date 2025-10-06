import 'package:equatable/equatable.dart';

abstract class SpecifierCreateState extends Equatable {
  const SpecifierCreateState();

  @override
  List<Object> get props => [];
}

class SpecifierCreateInitial extends SpecifierCreateState {}

class SpecifierCreateLoading extends SpecifierCreateState {}

class SpecifierCreateSuccess extends SpecifierCreateState {
  final String message;

  const SpecifierCreateSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class SpecifierCreateError extends SpecifierCreateState {
  final String error;
  const SpecifierCreateError({required this.error});

  @override
  List<Object> get props => [error];
}
