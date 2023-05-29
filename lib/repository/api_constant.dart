import 'package:http/http.dart' as http;

class APIConstant {
  static const String BASE_URL = 'https://it-fresher.edu.vn/nms';
}

class SignUpConstant {
  static const int statusSuccess = 1;
  static const int statusError = -1;
  static const int errorEmailExists = 2;
}

class SignInConstant {
  static const int statusSuccess = 1;
  static const int statusError = -1;
  static const int errorWrongPassword = 2;
  static const int errorNotFound = 1;
}
