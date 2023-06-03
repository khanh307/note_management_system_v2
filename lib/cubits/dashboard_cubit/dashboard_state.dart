import 'package:note_management_system_v2/models/Dashboard/dashboardDTO.dart';
import 'package:note_management_system_v2/models/Dashboard/dashboardModel.dart';

abstract class DashboardState {}

class InitialChartState extends DashboardState {}

class LoadingChartState extends DashboardState {}

class FailureChartState extends DashboardState {
  String message;

  FailureChartState(this.message);
}

class SuccessGetAllChartState extends DashboardState {
  final DashboardDTO? listChartStatus;

  SuccessGetAllChartState(this.listChartStatus);
}
