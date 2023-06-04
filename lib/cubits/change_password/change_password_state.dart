abstract class ChangePasswordState {}

class ChangePasswordInital extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFaliure extends ChangePasswordState {
  String error;
  ChangePasswordFaliure(this.error);
}