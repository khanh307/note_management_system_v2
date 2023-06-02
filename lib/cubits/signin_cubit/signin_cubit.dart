import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';

import 'package:note_management_system_v2/repository/signin_repository.dart';
import 'package:note_management_system_v2/repository/signup_repository.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  Future<void> login(Account account) async {
    emit(SignInLoadingState());

    try {
      var dataUser = await SignInRepository.login(account);

      if (dataUser.status == SignInConstant.statusSuccess) {
        final loginUser = Account(
            email: account.email,
            fristname: dataUser.info?['FirstName'],
            lastname: dataUser.info?['LastName']);
        emit(SignInSuccessState(loginUser));
      } else if (dataUser.status == SignInConstant.statusError &&
          dataUser.error == SignInConstant.errorWrongPassword) {
        emit(SignInErrorState('incorrect email address or password'));
      } else if (dataUser.status == SignInConstant.statusError &&
          dataUser.error == SignInConstant.errorNotFound) {
        emit(SignInErrorState('Account not found'));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }

  // sign in with gmail
  Future<void> signInGooGle(Account account) async {
    emit(SignInLoadingState());
    try {
      final gUser = await SignInRepository.login(account);
      if (gUser.status == SignInConstant.statusError &&
          gUser.error == SignInConstant.errorNotFound) {
        final addUserGoogle = await SignUpRepository.addAccount(account);
        if (addUserGoogle.status == SignUpConstant.statusSuccess) {
          emit(SignUpSuccessState() as SignInState);
        } else {
          emit(SignUpErrorState('ERROR') as SignInState);
        }
      } else {
        emit(SignInSuccessState(account));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}
