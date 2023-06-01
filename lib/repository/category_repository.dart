import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/models/category.dart';
import 'package:note_management_system_v2/models/response.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';

class CategoryRepository {
  final String email;

  CategoryRepository({required this.email});

  static const String urlRead =
      '${APIConstant.BASE_URL}/get?tab=Category&email=';
  static const String urlWrite =
      '${APIConstant.BASE_URL}/add?tab=Category&email=';
  static const String urlUpdate =
      '${APIConstant.BASE_URL}/update?tab=Category&email=';
  static const String urlDelete =
      '${APIConstant.BASE_URL}/del?tab=Category&email=';

  Future<List<Category>?> getAllCategory() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == 1) {
      Response result = Response.fromJson(parsed);
      final list = result.data
          ?.map<Category>((status) => Category.fromArray(status))
          .toList();

      return list;
    } else {
      return null;
    }
  }

  Future<Response> createCategory(Category category) async {
    final uri = Uri.parse('$urlWrite$email&name=${category.name}');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);

    return result;
  }

  Future<Response> updateCategory(String name, Category category) async {
    final uri = Uri.parse('$urlUpdate$email&name=$name&nname=${category.name}');
    final response = await http.get(uri);

    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);

    return result;
  }

  Future<Response> deleteCategory(String name) async {
    final uri = Uri.parse('$urlDelete$email&name=$name');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);
    return result;
  }
}
