
import 'package:note_management_system_v2/models/response.dart';

class Priority extends Response{
  String? id;

  Priority({required super.status, super.error, this.id});

}