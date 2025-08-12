import 'package:equatable/equatable.dart';

abstract class DashboardTransporterState extends Equatable {
  const DashboardTransporterState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardTransporterState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardTransporterState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardTransporterState {
  final Map<String, dynamic> dashboardData;

  const DashboardLoaded(this.dashboardData);

  @override
  List<Object> get props => [dashboardData];
}

class DashboardError extends DashboardTransporterState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
