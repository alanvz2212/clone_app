import 'package:equatable/equatable.dart';
import '../models/scheme_dealer_model.dart';

abstract class SchemeDealerState extends Equatable {
  const SchemeDealerState();

  @override
  List<Object?> get props => [];
}

class SchemeInitial extends SchemeDealerState {}

class SchemeLoading extends SchemeDealerState {}

class SchemeRefreshing extends SchemeDealerState {
  final List<SchemeDealerModel> currentSchemes;

  const SchemeRefreshing({required this.currentSchemes});

  @override
  List<Object?> get props => [currentSchemes];
}

class SchemeLoaded extends SchemeDealerState {
  final List<SchemeDealerModel> schemes;
  final int userId;

  const SchemeLoaded({required this.schemes, required this.userId});

  @override
  List<Object?> get props => [schemes, userId];
}

class SchemeEmpty extends SchemeDealerState {
  final int userId;

  const SchemeEmpty({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SchemeError extends SchemeDealerState {
  final String message;
  final int userId;

  const SchemeError({required this.message, required this.userId});

  @override
  List<Object?> get props => [message, userId];
}
