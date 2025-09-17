import 'package:equatable/equatable.dart';
abstract class DashboardTransporterEvent extends Equatable {
  const DashboardTransporterEvent();
  @override
  List<Object> get props => [];
}
class LoadDashboard extends DashboardTransporterEvent {
  const LoadDashboard();
}
class RefreshDashboard extends DashboardTransporterEvent {
  const RefreshDashboard();
}
class UpdateDashboardData extends DashboardTransporterEvent {
  final Map<String, dynamic> data;
  const UpdateDashboardData(this.data);
  @override
  List<Object> get props => [data];
}

