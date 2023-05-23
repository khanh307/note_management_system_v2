
import 'package:note_management_system_v2/models/response.dart';

class Note extends Response{
  String? id;

  Note({required super.status, super.error, this.id});
}