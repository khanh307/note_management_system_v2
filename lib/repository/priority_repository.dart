import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/models/priority.dart';
import 'package:note_management_system_v2/models/response.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';


class PriorityRepository {
  final String email;

  PriorityRepository({required this.email});

  static const String urlRead = '${APIConstant.BASE_URL}/get?tab=Priority&email=';
  static const String urlWrite =
      '${APIConstant.BASE_URL}/add?tab=Priority&email=';
  static const String urlUpdate =
      '${APIConstant.BASE_URL}/update?tab=Priority&email=';
  static const String urlDelete =
      '${APIConstant.BASE_URL}/del?tab=Priority&email=';

  Future<List<PriorityModel>?> getAllPriorities() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == 1 && parsed['data'] != null) {
      Response result = Response.fromJson(parsed);
      final list = result.data
          ?.map<PriorityModel>((status) => PriorityModel.fromArray(status))
          .toList();

      return list;
    } else {
      return null;
    }
  }

  Future<Response> createPriority(PriorityModel priority) async {
    final uri = Uri.parse('$urlWrite$email&name=${priority.name}');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);

    return result;
  }

  Future<Response> updatePriority(String name, PriorityModel priority) async {
    final uri = Uri.parse('$urlUpdate$email&name=$name&nname=${priority.name}');
    final response = await http.get(uri);
    debugPrint(uri.toString());
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);

    return result;
  }

  Future<Response> deletePriority(String name) async {
    final uri = Uri.parse('$urlDelete$email&name=$name');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);
    return result;
  }
}
