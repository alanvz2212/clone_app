import 'package:equatable/equatable.dart';

abstract class SchemeSpecifierEvent extends Equatable {
  const SchemeSpecifierEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchemes extends SchemeSpecifierEvent {
  final int userId;

  const LoadSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshSchemes extends SchemeSpecifierEvent {
  final int userId;

  const RefreshSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RetryLoadSchemes extends SchemeSpecifierEvent {
  final int userId;

  const RetryLoadSchemes({required this.userId});

  @override
  List<Object?> get props => [userId];
}
