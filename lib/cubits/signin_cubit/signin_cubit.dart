import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';

import 'package:note_management_system_v2/repository/signin_repository.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(context, Account account) async {
    emit(SignInLoadingState());
    debugPrint(account.password);
    try {
      var dataUser = await SignInRepository.login(account);

      if (dataUser.status == SignInConstant.statusSuccess) {
        final loginUser = Account(
            email: account.email,
            password: account.password,
            fristname: dataUser.info?['FirstName'],
            lastname: dataUser.info?['LastName']);
        emit(SignInSuccessState(loginUser));
      } else if (dataUser.status == SignInConstant.statusError &&
          dataUser.error == SignInConstant.errorWrongPassword) {
        emit(SignInErrorState(translation(context).incorrectEmailPass));
      } else if (dataUser.status == SignInConstant.statusError &&
          dataUser.error == SignInConstant.errorNotFound) {
        emit(SignInErrorState(translation(context).notFoundAcc));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }

  // sign in with gmail
  Future<void> signInGooGle(context, Account account) async {
    emit(SignInLoadingState());
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        emit(SignInSuccessState(account));
      } else {
        emit(SignInErrorState(translation(context).signinGGFail));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}
