import 'package:note_management_system_v2/models/status.dart';

abstract class StatusState {}

class InitialStatusState extends StatusState {}

class LoadingStatusState extends StatusState {}

class SuccessGetAllStatusState extends StatusState {
  final List<Status>? listStatus;

  SuccessGetAllStatusState(this.listStatus);
}

class SuccessDeleteStatusState extends StatusState {}

class ErrorDeleteStatusState extends StatusState {
  String message;

  ErrorDeleteStatusState(this.message);
}
