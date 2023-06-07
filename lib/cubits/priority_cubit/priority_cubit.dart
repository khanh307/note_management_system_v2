import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/priority_cubit/priority_state.dart';
import 'package:note_management_system_v2/models/priority.dart';
import 'package:note_management_system_v2/repository/priority_repository.dart';

class PriorityCubit extends Cubit<PriorityState> {
  final PriorityRepository _priorityRepository;

  PriorityCubit(this._priorityRepository) : super(InitialPriorityState());

  Future<void> getAllPriorities() async {
    emit(LoadingPriorityState());
    try {
      var result = await _priorityRepository.getAllPriorities();
      emit(SuccessGetAllPriorityState(result));
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
  }

  //Ghi
  Future<void> createPriority(context, PriorityModel priority) async {
    try {
      var result = await _priorityRepository.createPriority(priority);
      if (result.status == 1) {
        emit(SuccessSubmitPriorityState(priority));
      } else if (result.status == -1 && result.status == 2) {
        emit(ErrorSubmitStateState(translation(context).existName));
      }
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
  }

  Future<void> updatePriority(
      context, String name, PriorityModel priority) async {
    try {
      var result = await _priorityRepository.updatePriority(name, priority);
      if (result.status == 1) {
        emit(SuccessUpdatePriorityState(priority));
      } else if (result.status == -1) {
        emit(ErrorUpdatePriorityState(translation(context).err));
      }
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
  }

  // Xóa
  Future<void> deletePriority(context, String name) async {
    try {
      var result = await _priorityRepository.deletePriority(name);
      if (result.status == 1) {
        emit(SuccessDeletePriorityState());
      } else if (result.status == -1 && result.error == 2) {
        emit(ErrorDeletePriorityState(
            '$name' + translation(context).existinNote));
      }
    } catch (e) {
      emit(FailurePriorityState(e.toString()));
    }
  }
}
