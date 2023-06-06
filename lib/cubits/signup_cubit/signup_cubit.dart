import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';
import 'package:note_management_system_v2/cubits/signup_cubit/signup_state.dart';
import 'package:note_management_system_v2/models/account.dart';

import 'package:note_management_system_v2/repository/api_constant.dart';

import 'package:note_management_system_v2/repository/signup_repository.dart';

class SignUpCubit extends Cubit<SignUpSate> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> addAccount(context, Account account) async {
    emit(SignUpLoadingState());
    try {
      final data = await SignUpRepository.addAccount(account);

      if (data.status == SignUpConstant.statusSuccess) {
        emit(SignUpSuccessState());
      } else if (data.status == SignUpConstant.statusError &&
          data.error == SignUpConstant.errorEmailExists) {
        emit(SignUpErrorState(translation(context).emailExist));
      }
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }
}
