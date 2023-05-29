import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:http/http.dart' as http;

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  void login(User user) async {
    emit(SignInLoadingState());
    final url =
        '${APIConstant.BASE_URL}/login?email=${user.email}&pass=${user.password}';

    try {
      final response = await http.get(Uri.parse(url));
      final dataUser = jsonDecode(response.body);

      if (dataUser['status'] == SignInConstant.statusSuccess) {
        final loginUser = User(
            email: user.email,
            firstname: dataUser['info']['FirstName'],
            lastname: dataUser['info']['LastName']);
        emit(SignInSuccessState(loginUser));
      } else if (dataUser['status'] == SignInConstant.statusError &&
          dataUser['error'] == SignInConstant.errorWrongPassword) {
        emit(SignInErrorState('incorrect email address or password'));
      } else if (dataUser['status'] == SignInConstant.statusError &&
          dataUser['error'] == SignInConstant.errorNotFound) {
        emit(SignInErrorState('Account not found'));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}
