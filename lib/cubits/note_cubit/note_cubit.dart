import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/note_cubit/note_state.dart';
import 'package:note_management_system_v2/models/note.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:note_management_system_v2/repository/note_repository.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _noteRepository;

  NoteCubit(this._noteRepository) : super(InitialNoteState());

  Future<void> getAllNotes() async {
    emit(LoadingNoteState());
    try {
      var result = await _noteRepository.getAllNotes();
      emit(SuccessGetAllNoteState(result));
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }

  //Ghi
  Future<void> createNote(context, Note note) async {
    try {
      var result = await _noteRepository.createNote(note);
      if (result.status == APIConstant.statusSuccess) {
        emit(SuccessSubmitNoteState(note));
      } else if (result.status == APIConstant.statusError &&
          result.error == APIConstant.errorDuplicate) {
        emit(ErrorSubmitNoteState(translation(context).existName));
      }
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }

  Future<void> updateNote(context, String name, Note note) async {
    try {
      var result = await _noteRepository.updateNote(name, note);
      if (result.status == APIConstant.statusSuccess) {
        emit(SuccessUpdateNoteState(note));
      } else if (result.status == APIConstant.statusError) {
        emit(ErrorUpdateNoteState(translation(context).err));
      }
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }

  // Xóa
  Future<void> deleteNote(context, String name) async {
    try {
      var result = await _noteRepository.deleteNote(name);
      if (result.status == APIConstant.statusSuccess) {
        emit(SuccessDeleteNoteState());
      } else if (result.status == APIConstant.statusError &&
          result.error == APIConstant.errorDuplicate) {
        emit(ErrorDeleteNoteState(translation(context).cantDel + '$name'));
      }
    } catch (e) {
      emit(FailureNoteState(e.toString()));
    }
  }
}
