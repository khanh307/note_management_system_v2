import 'package:note_management_system_v2/models/note.dart';

abstract class NoteState {}

class InitialNoteState extends NoteState {}

class LoadingNoteState extends NoteState {}

class FailureNoteState extends NoteState {
  String message;

  FailureNoteState(this.message);
}

class SuccessGetAllNoteState extends NoteState {
  final List<Note>? listNote;

  SuccessGetAllNoteState(this.listNote);
}

class SuccessDeleteNoteState extends NoteState {}

class ErrorDeleteNoteState extends NoteState {
  String message;

  ErrorDeleteNoteState(this.message);
}

class SuccessSubmitNoteState extends NoteState {
  Note note;

  SuccessSubmitNoteState(this.note);
}

class ErrorSubmitNoteState extends NoteState {
  String message;

  ErrorSubmitNoteState(this.message);
}

class SuccessUpdateNoteState extends NoteState {
  Note note;

  SuccessUpdateNoteState(this.note);
}

class ErrorUpdateNoteState extends NoteState {
  String message;

  ErrorUpdateNoteState(this.message);
}
