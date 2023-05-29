import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/status_cubit/status_state.dart';
import 'package:note_management_system_v2/models/status.dart';
import 'package:note_management_system_v2/repository/status_repository.dart';

class StatusCubit extends Cubit<StatusState> {
  final StatusRepository _statusRepository;

  StatusCubit(this._statusRepository) : super(InitialStatusState());

  Future<void> getAllStatus() async {
    emit(LoadingStatusState());
    try {
      var result = await _statusRepository.getAllProfile();
      emit(SuccessGetAllStatusState(result));
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
  }

  //Ghi
  Future<void> createStatus(Status status) async {
    try {
      var result = await _statusRepository.createStatus(status);
      if (result.status == 1) {
        emit(SuccessSubmitStatusState(status));
      } else if (result.status == -1 && result.error == 2) {
        emit(ErrorSubmitStatusState('* Please enter a different name, this name already exists'));
      }
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
  }

  Future<void> updateStatus(String name, Status status) async {
    try {
      var result = await _statusRepository.updateStatus(name, status);
      if(result.status == 1) {
        emit(SuccessUpdateStatusState(status));
      } else if (result.status == -1){
        emit(ErrorUpdateStatusState('* Lỗi'));
      }
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
  }

  // Xóa
  Future<void> deleteStatus(String name) async {
    try {
      var result = await _statusRepository.deleteStatus(name);
      if (result.status == 1) {
        emit(SuccessDeleteStatusState());
      } else if (result.status == -1 && result.error == 2) {
        emit(ErrorDeleteStatusState(
            '* Can\'t delete this $name because it already exists in note'));
      }
    } catch (e) {
      emit(FailureStatusState(e.toString()));
    }
  }
}
