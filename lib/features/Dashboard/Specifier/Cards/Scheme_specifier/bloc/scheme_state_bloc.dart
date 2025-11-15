import 'package:abm4customerapp/features/Dashboard/Specifier/Cards/Scheme_specifier/model/scheme_specifier_model.dart';
import 'package:equatable/equatable.dart';

abstract class SchemeSpecifierState extends Equatable {
  const SchemeSpecifierState();

  @override
  List<Object?> get props => [];
}

class SchemeInitial extends SchemeSpecifierState {}

class SchemeLoading extends SchemeSpecifierState {}

class SchemeRefreshing extends SchemeSpecifierState {
  final List<SchemeSpecifierModel> currentSchemes;

  const SchemeRefreshing({required this.currentSchemes});

  @override
  List<Object?> get props => [currentSchemes];
}

class SchemeLoaded extends SchemeSpecifierState {
  final List<SchemeSpecifierModel> schemes;
  final int userId;

  const SchemeLoaded({required this.schemes, required this.userId});

  @override
  List<Object?> get props => [schemes, userId];
}

class SchemeEmpty extends SchemeSpecifierState {
  final int userId;

  const SchemeEmpty({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SchemeError extends SchemeSpecifierState {
  final String message;
  final int userId;

  const SchemeError({required this.message, required this.userId});

  @override
  List<Object?> get props => [message, userId];
}
