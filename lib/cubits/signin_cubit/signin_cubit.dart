import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_state.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:http/http.dart' as http;

class SignInCubit extends Cubit<SignInState> {


  SignInCubit() : super(SignInInitial());

  void login(String email, String password) async {
    emit(SignInLoadingState());
    final url = '${APIConstant.BASE_URL}/login?email=$email&pass=$password';

    try {
      final response = await http.get(Uri.parse(url));
      final dataUser = jsonDecode(response.body);

      if (dataUser['status'] == 1) {
        User user = User(
          email: email,
          firstname: dataUser['info']['FirstName'],
          lastname: dataUser['info']['LastName']
        );
        emit(SignInSuccessState(user));
      } else if (dataUser['status'] == -1 && dataUser['error'] == 2) {
        emit(SignInErrorState('incorrect email address or password'));
      } else if (dataUser['status'] == -1 && dataUser['error'] == 1) {
        emit(SignInErrorState('Account not found'));
      }
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}
