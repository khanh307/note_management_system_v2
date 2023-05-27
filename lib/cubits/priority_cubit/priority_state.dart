import '../../models/priority.dart';

abstract class PriorityState {}

class InitialPriorityState extends PriorityState {}

class LoadingPriorityState extends PriorityState {}

class FailurePriorityState extends PriorityState {
  String message;

  FailurePriorityState(this.message);
}

class SuccessGetAllPriorityState extends PriorityState {
  final List<PriorityModel>? listPriority;

  SuccessGetAllPriorityState(this.listPriority);
}

class SuccessDeletePriorityState extends PriorityState {

}

class ErrorDeletePriorityState extends PriorityState {
  String message;

  ErrorDeletePriorityState(this.message);
}

class SuccessSubmitPriorityState extends PriorityState {
  PriorityModel priority;

  SuccessSubmitPriorityState(this.priority);
}

class ErrorSubmitStateState extends PriorityState {
  String message;

  ErrorSubmitStateState(this.message);
}

class SuccessUpdatePriorityState extends PriorityState {
  PriorityModel priority;

  SuccessUpdatePriorityState(this.priority);
}

class ErrorUpdatePriorityState extends PriorityState {
  String message;

  ErrorUpdatePriorityState(this.message);
}
