import 'package:intl/intl.dart';
import 'package:note_management_system_v2/Localization/language_constant.dart';

class NoteValidator {
  static String? categoryValidate(context, String? value) {
    if (value == null) {
      return translation(context).noPickCate;
    }
    return null;
  }

  static String? priorityValidate(context, String? value) {
    if (value == null) {
      return translation(context).noPickprio;
    }
    return null;
  }

  static String? statusValidate(context, String? value) {
    if (value == null) {
      return translation(context).noPickstatus;
    }
    return null;
  }

  static String? planDateValidate(context, String? value) {
    if (value == null || value.isEmpty) {
      return translation(context).noPickdate;
    }
    DateTime now = DateTime.now();
    if (DateFormat('dd/MM/yyyy')
        .parse(value!)
        .isBefore(DateTime(now.year, now.month, now.day))) {
      return translation(context).curDate;
    }

    return null;
  }
}
