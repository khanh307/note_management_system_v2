import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';

class StatusCubit extends Cubit<StatusState> {
  final StatusRepository _statusRepository;

  StatusCubit(this._statusRepository) : super(InitialStatusState());

  Future<void> getAllStatus() async {
    emit(LoadingStatusState());
    try {
      var result = await _statusRepository.getAllProfile();
      emit(SuccessGetAllStatusState(result));
    } catch (e) {}
  }

  Future<void> deleteStatus(String name) async {
    emit(LoadingStatusState());
    try {
      var result = await _statusRepository.deleteStatus(name);
      if (result.error == 2) {
        emit(ErrorDeleteStatusState(
            '* Can\'t delete this $name because it already exists in note'));
      }
      emit(SuccessDeleteStatusState());
    } catch (e) {

    }
  }


}
