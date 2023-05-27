import 'package:note_management_system_v2/models/user.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  User user;

  SignInSuccessState(this.user);
}

class SignInErrorState extends SignInState {
  final String errorMessage;

  SignInErrorState(this.errorMessage);
}
