import 'dart:convert';

import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:http/http.dart' as http;
import 'api_constant.dart';

class SignUpRepository {
  static Future<User> addAccount(Account account) async {
    final url =
        '${APIConstant.BASE_URL}/signup?email=${account.email}&pass=${account.password}&firstname=${account.fristname}&lastname=${account.lastname}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to signUp');
    }
  }
}
