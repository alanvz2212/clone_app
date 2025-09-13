import 'package:equatable/equatable.dart';

abstract class DealerAuthEvent extends Equatable {
  const DealerAuthEvent();

  @override
  List<Object> get props => [];
}

class DealerLoginRequested extends DealerAuthEvent {
  final String mobileNumberOrId;
  final String password;
  final bool stayLoggedIn;

  const DealerLoginRequested({
    required this.mobileNumberOrId,
    required this.password,
    this.stayLoggedIn = false,
  });

  @override
  List<Object> get props => [mobileNumberOrId, password, stayLoggedIn];
}

class DealerLogoutRequested extends DealerAuthEvent {}

class DealerAuthRestoreRequested extends DealerAuthEvent {}

class DealerForgotPasswordRequested extends DealerAuthEvent {
  final String mobileNumberOrId;

  const DealerForgotPasswordRequested({required this.mobileNumberOrId});

  @override
  List<Object> get props => [mobileNumberOrId];
}