import 'package:intl/intl.dart';

class NoteValidator {
  static String? categoryValidate(String? value) {
    if (value == null) {
      return '* Please select a category';
    }
    return null;
  }

  static String? priorityValidate(String? value) {
    if (value == null) {
      return '* Please select a priority';
    }
    return null;
  }

  static String? statusValidate(String? value) {
    if (value == null) {
      return '* Please select a status';
    }
    return null;
  }

  static String? planDateValidate(String? value) {
    if (value == null || value.isEmpty) {
      return '* Please select a completion date';
    }
    DateTime now = DateTime.now();
    if (DateFormat('dd/MM/yyyy')
        .parse(value!)
        .isBefore(DateTime(now.year, now.month, now.day))) {
      return '* Please select a completion date starting from the current date';
    }

    return null;
  }
}
