import 'package:equatable/equatable.dart';

abstract class SchemeDealerEvent extends Equatable {
  const SchemeDealerEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchemes extends SchemeDealerEvent {
  final int userId;

  const LoadSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshSchemes extends SchemeDealerEvent {
  final int userId;

  const RefreshSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RetryLoadSchemes extends SchemeDealerEvent {
  final int userId;

  const RetryLoadSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}
