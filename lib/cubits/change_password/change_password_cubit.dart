import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/change_password/change_password_state.dart';

import '../../repository/api_constant.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInital());

  Future<void> changePassword(context,
      {required String email,
      required String password,
      required String newPassword}) async {
    emit(ChangePasswordLoading());
    final url =
        '${APIConstant.BASE_URL}/update?tab=Profile&email=$email&pass=$password&npass=$newPassword';
    debugPrint(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final status = jsonResponse['status'];
        if (status == ChangePasswordConstant.statusSuccess) {
          emit(ChangePasswordSuccess());
        } else {
          emit(ChangePasswordFaliure(translation(context).changePassFail));
        }
      }
    } catch (e) {
      emit(ChangePasswordFaliure(e.toString()));
    }
  }
}
