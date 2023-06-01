import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/dashbard_cubit/dashboard_state.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/repository/dashboard_repository.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardCubit(this._dashboardRepository) : super(InitialChartState());

  Future<void> getAllStatusCharts() async {
    emit(LoadingChartState());
    try {
      var result = await _dashboardRepository.getAllChart();

      emit(SuccessGetAllChartState(result));
    } catch (e) {
      emit(FailureChartState(e.toString()));
    }
  }
}
