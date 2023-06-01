import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/models/user.dart';

import 'api_constant.dart';

class SignInRepository {
  static Future<User> login(Account account) async {
    final url =
        '${APIConstant.BASE_URL}/login?email=${account.email}&pass=${account.password}';
      debugPrint(url.toString());
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to login');
  }
}
}
