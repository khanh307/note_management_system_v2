import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:http/http.dart' as http;

class SignUpCubit extends Cubit<SignUpSate> {
  SignUpCubit() : super(SignUpInitial());

  void signUp(
      String email, String password, String firstName, String lastName) async {
    emit(SignUpLoadingState());
    final url =
        '${APIConstant.BASE_URL}/signup?email=$email&pass=$password&firstname=$firstName&lastname=$lastName';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 1) {
        emit(SignUpSucessState());
      } else if (data['status'] == -1 && data['error'] == 2) {
        emit(SignUpErrorState('Email already exists'));
      } else {
        emit(SignUpErrorState('An error occurred'));
      }
    } catch (e) {
      emit(SignUpErrorState('An error occurred'));
    }
  }
}
