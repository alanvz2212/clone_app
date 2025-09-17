import 'package:clone/features/Dashboard/Transporter/Bloc/dashboard_transporter_event.dart';
import 'package:clone/features/Dashboard/Transporter/Bloc/dashboard_transporter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class DashboardBloc
    extends Bloc<DashboardTransporterEvent, DashboardTransporterState> {
  DashboardBloc() : super(DashboardInitial()) {
  }
}

