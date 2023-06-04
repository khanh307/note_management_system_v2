import 'package:note_management_system_v2/models/account.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  Account account;

  SignInSuccessState(this.account);
}

class SignInErrorState extends SignInState {
  final String errorMessage;

  SignInErrorState(this.errorMessage);
}
