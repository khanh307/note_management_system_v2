import 'package:note_management_system_v2/utils/regex/regex.dart';

class ValidateVietNamese {
  static String? valiEmailSignIn(String? value) {
    if (value == null || value.isEmpty) {
      return '* Vui lòng nhập địa chỉ email';
    }

    if (!isValidEmail(value)) {
      return '* Địa chỉ email hoặc mật khẩu không đúng';
    }
    return null;
  }

  static String? valiPasswordSignIn(String? value) {
    if (value == null || value.isEmpty) {
      return '* Vui lòng nhập mật khẩu';
    }

    if (!isPasswordValid(value)) {
      return "* Địa chỉ email hoặc mật khẩu không đúng";
    }
    return null;
  }

  static String? valiEmailSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return '* Vui lòng nhập địa chỉ email';
    }

    if (value.trim().length < 6) {
      return '* Vui lòng nhập tối thểu 6 ký tự';
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
      return '* Địa chỉ email không đúng';
    }

    return null;
  }

  static String? valiPasswordSignUp(String? value) {
    if (value == null || value.isEmpty) {
      return '* Vui lòng nhập mật khẩu';
    }

    if (value.trim().length < 6 || value.trim().length > 32) {
      return '* Mật khẩu phải có độ dài từ 6 đến 32 ký tự';
    }

    RegExp upperCase = RegExp(r'[A-Z]');
    if (!upperCase.hasMatch(value)) {
      return '* Vui lòng nhập ít nhất 1 chữ in hoa';
    }

    RegExp digit = RegExp(r'[0-9]');
    if (!digit.hasMatch(value)) {
      return '* Vui lòng nhập ít nhất 1 số';
    }

    return null;
  }
}
