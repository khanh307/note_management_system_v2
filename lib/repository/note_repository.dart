import 'dart:convert';

import 'package:note_management_system_v2/models/note.dart';
import 'package:note_management_system_v2/models/response.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';
import 'package:http/http.dart' as http;

class NoteRepository {
  final String email;

  NoteRepository({required this.email});

  static const String urlRead = '${APIConstant.BASE_URL}/get?tab=Note&email=';
  static const String urlWrite = '${APIConstant.BASE_URL}/add?tab=Note&email=';
  static const String urlUpdate =
      '${APIConstant.BASE_URL}/update?tab=Note&email=';
  static const String urlDelete = '${APIConstant.BASE_URL}/del?tab=Note&email=';

  Future<List<Note>?> getAllNotes() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == APIConstant.statusSuccess && parsed['data'] != null) {
      Response result = Response.fromJson(parsed);
      final list =
          result.data?.map<Note>((note) => Note.fromArray(note)).toList();

      return list;
    } else {
      return null;
    }
  }

  Future<Response> createNote(Note note) async {
    final uri =
        Uri.parse('''$urlWrite$email&name=${note.name}&Priority=${note.priority}
        &Category=${note.category}&Status=${note.status}&PlanDate=${note.planDate}''');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);
    Response result = Response.fromJson(parsed);
    return result;
  }

  Future<Response> updateNote(String oldName, Note note) async {
    final uri = Uri.parse(
        '''$urlUpdate$email&name=$oldName&nname=${note.name}&Priority=${note.priority}
        &Category=${note.category}&Status=${note.status}&PlanDate=${note.planDate}''');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);
    Response result = Response.fromJson(parsed);
    return result;
  }

  Future<Response> deleteNote(String name) async {
    final uri = Uri.parse('$urlDelete$email&name=$name');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    Response result = Response.fromJson(parsed);
    return result;
  }
}
