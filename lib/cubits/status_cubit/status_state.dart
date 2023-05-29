import 'package:note_management_system_v2/models/status.dart';

abstract class StatusState {}

class InitialStatusState extends StatusState {}

class LoadingStatusState extends StatusState {}

class FailureStatusState extends StatusState {
  String message;

  FailureStatusState(this.message);
}

class SuccessGetAllStatusState extends StatusState {
  final List<Status>? listStatus;

  SuccessGetAllStatusState(this.listStatus);
}

class SuccessDeleteStatusState extends StatusState {

}

class ErrorDeleteStatusState extends StatusState {
  String message;

  ErrorDeleteStatusState(this.message);
}

class SuccessSubmitStatusState extends StatusState {
  Status status;

  SuccessSubmitStatusState(this.status);
}

class ErrorSubmitStatusState extends StatusState {
  String message;

  ErrorSubmitStatusState(this.message);
}

class SuccessUpdateStatusState extends StatusState {
  Status status;

  SuccessUpdateStatusState(this.status);
}

class ErrorUpdateStatusState extends StatusState {
  String message;

  ErrorUpdateStatusState(this.message);
}
