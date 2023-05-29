import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:http/http.dart' as http;

class SignUpCubit extends Cubit<SignUpSate> {
  SignUpCubit() : super(SignUpInitial());

  void addAccount(User user) async {
    emit(SignUpLoadingState());
    final url =
        '${APIConstant.BASE_URL}/signup?email=${user.email}&pass=${user.password}&firstname=${user.firstname}&lastname=${user.lastname}';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == SignUpConstant.statusSuccess) {
        emit(SignUpSuccessState());
      } else if (data['status'] == SignUpConstant.statusError &&
          data['error'] == SignUpConstant.errorEmailExists) {
        emit(SignUpErrorState('Email already exists'));
      }
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }
}
