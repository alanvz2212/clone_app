import 'package:equatable/equatable.dart';

abstract class TransporterAuthEvent extends Equatable {
  const TransporterAuthEvent();

  @override
  List<Object> get props => [];
}

class TransporterLoginRequested extends TransporterAuthEvent {
  final String mobileNumberOrId;
  final String password;

  const TransporterLoginRequested({
    required this.mobileNumberOrId,
    required this.password,
  });

  @override
  List<Object> get props => [mobileNumberOrId, password];
}

class TransporterLogoutRequested extends TransporterAuthEvent {}

class TransporterForgotPasswordRequested extends TransporterAuthEvent {
  final String mobileNumberOrId;

  const TransporterForgotPasswordRequested({required this.mobileNumberOrId});

  @override
  List<Object> get props => [mobileNumberOrId];
}