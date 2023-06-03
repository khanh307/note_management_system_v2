import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/dashboard_cubit/dashboard_state.dart';
import 'package:note_management_system_v2/repository/dashboardRepository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardCubit(this._dashboardRepository) : super(InitialChartState());

  Future<void> getAllStatusCharts() async {
    emit(LoadingChartState());
    try {
      var result = await _dashboardRepository.getAllChartData();

      emit(SuccessGetAllChartState(result));
    } catch (e) {
      emit(FailureChartState(e.toString()));
    }
  }
}
