import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/models/response.dart';
import 'package:note_management_system_v2/models/status.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';

class StatusRepository {
  final String email;

  StatusRepository({required this.email});

  static const String urlRead = '${APIConstant.BASE_URL}/get?tab=Status&email=';
  static const String urlWrite = '${APIConstant.BASE_URL}/add?tab=Status&';
  static const String urlUpdate = '${APIConstant.BASE_URL}/update?tab=Status&';
  static const String urlDelete = '${APIConstant.BASE_URL}/delete?tab=Status&';

  Future<List<Status>?> getAllProfile() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == 1 && parsed['data'] != null) {
      Response result = Response.fromJson(parsed);
      final list = result.data
          ?.map<Status>((status) => Status.fromArray(status))
          .toList();

      return list;
    } else {
      return null;
    }
  }

  Future<Response> deleteStatus(String name) async {
    final uri = Uri.parse('$urlDelete$email&name=$name');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);
    return result;
  }
}
