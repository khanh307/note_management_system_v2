import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/cubits/change_password/change_password_state.dart';

import '../../repository/api_constant.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInital());

  Future<void> changePassword(
      {required String email,
      required String password,
      required String newPassword}) async {
    emit(ChangePasswordLoading());
    final url =
        '${APIConstant.BASE_URL}/update?tab=Profile&email=$email&pass=$password&npass=$newPassword';
    try {
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final status = jsonResponse['status'];
        if(status == ChangePasswordConstant.statusSuccess) {
          emit(ChangePasswordSuccess());
        } else {
          emit(ChangePasswordFaliure('Change password failed'));
        }
      }
    } catch (e) {
      emit(ChangePasswordFaliure(e.toString()));
    }
  }
}
