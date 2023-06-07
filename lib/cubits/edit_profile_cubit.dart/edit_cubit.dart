import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/edit_profile_cubit.dart/edit_state.dart';

import '../../repository/api_constant.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  Future<void> updateProfile(context,
      {required String email,
      required String nemail,
      required String firstname,
      required String lastname}) async {
    emit(EditProfileLoading());
    final url =
        '${APIConstant.BASE_URL}/update?tab=Profile&email=$email&nemail=$nemail&firstname=$firstname&lastname=$lastname';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final status = jsonResponse['status'];
        if (status == EditConstant.statusSuccess) {
          emit(EditProfileSuccess());
        } else {
          emit(EditProfileFaileure(translation(context).upFail));
        }
      }
    } catch (e) {
      emit(EditProfileFaileure(e.toString()));
    }
  }
}
