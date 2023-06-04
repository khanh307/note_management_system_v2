import 'package:note_management_system_v2/utils/regex/regex.dart';

class ValidateEnglish {
  //function validate email sign in
  static String? valiEmailSignIn(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your email';
    }

    if (!isValidEmail(value)) {
      return '* Email address or password is incorrect';
    }
    return null;
  }

  //function validate password sign in
  static String? valiPasswordSignIn(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter a password';
    }

    if (!isPasswordValid(value)) {
      return "* Email address or password is incorrect";
    }
    return null;
  }

  //function validate email sign up
  static String? valiEmailSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your email address';
    }

    if (value.trim().length < 6) {
      return '* Please enter at least 6 characters';
    }

    if (value.contains('..') ||
        value.startsWith('.') ||
        value.endsWith('.') ||
        value.endsWith('@') ||
        value.contains('-@') ||
        value.contains('@-') ||
        value.contains('..') ||
        RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '* Email address is incorrect';
    }

    final List<String> parts = value.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return '* Email address is incorrect';
    }

    if (RegExp(r'[^\w\s@.-]').hasMatch(value)) {
      return '* Email address is incorrect';
    }

    return null;
  }

  //function validate password sign up
  static String? valiPasswordSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your password';
    }

    if (value.trim().length < 6 || value.trim().length > 32) {
      return '* Password must be between 6 and 32 characters in length';
    }

    RegExp upperCase = RegExp(r'[A-Z]');
    if (!upperCase.hasMatch(value)) {
      return '* Please enter at least 1 capital letter';
    }

    RegExp digit = RegExp(r'[0-9]');
    if (!digit.hasMatch(value)) {
      return '* Please enter at least 1 number';
    }

    return null;
  }

  //function validate firstname edit
  static String? validateFirstnameEdit(String? value) {
    if (value == null || value.isEmpty) {
      return "* Please enter your firstname and lastname";
    }

    if (value.trim().length < 2 || value.trim().length > 32) {
      return "* First and last names must be between 2 and 32 characters long";
    }

    if (value.endsWith(' ')) {
      return "* Please do not end with a space";
    }

    return null;
  }

  //function validate lastname edit
  static String? validateLastnameEdit(String? value) {
    if (value == null || value.isEmpty) {
      return "* Please enter your name";
    }

    if (value.length < 2 || value.length > 32) {
      return "* Name must be between 2 and 32 characters in length";
    }

    if (value.endsWith(' ')) {
      return "* Please do not end with a space";
    }
    return null;
  }

  //function validate change password
  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your password';
    }

    if (value.trim().length < 6 || value.trim().length > 32) {
      return '* Password must be between 6 and 32 characters in length';
    }

    RegExp upperCase = RegExp(r'[A-Z]');
    if (!upperCase.hasMatch(value)) {
      return '* Please enter at least 1 capital letter';
    }

    RegExp digit = RegExp(r'[0-9]');
    if (!digit.hasMatch(value)) {
      return '* Please enter at least 1 number';
    }

    return null;
  }

  static String? validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please enter your password';
    }

    return null;
  }
}
