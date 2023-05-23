import 'package:note_management_system_v2/models/response.dart';

class Status extends Response {
  String? id;

  Status({required super.status, super.error, this.id});
}
