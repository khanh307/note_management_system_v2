//function regex email
bool isValidEmail(String email) {
  String pattern =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{0,9}$'; // Format email
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email) && email.length >= 6 && email.length <= 256;
}

//function regex password
bool isPasswordValid(String password) {
  if (password.length < 6 || password.length > 32) {
    return false;
  }

  final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,32}$');
  return passwordRegex.hasMatch(password);
}
