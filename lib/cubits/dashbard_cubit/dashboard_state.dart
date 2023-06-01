import 'package:note_management_system_v2/models/dashboard.dart';
import 'package:note_management_system_v2/models/status.dart';

abstract class DashboardState {}

class InitialChartState extends DashboardState {}

class LoadingChartState extends DashboardState {}

class FailureChartState extends DashboardState {
  String message;

  FailureChartState(this.message);
}

class SuccessGetAllChartState extends DashboardState {
  final List<DashboardModel>? listChartStatus;

  SuccessGetAllChartState(this.listChartStatus);
}
