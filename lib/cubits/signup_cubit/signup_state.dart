abstract class SignUpSate {}

class SignUpInitial extends SignUpSate {}

class SignUpLoadingState extends SignUpSate {}

class SignUpSuccessState extends SignUpSate {}

class SignUpErrorState extends SignUpSate {
  final String errorMessage;

  SignUpErrorState(this.errorMessage);
}
