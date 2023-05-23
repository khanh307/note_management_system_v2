
import 'package:note_management_system_v2/models/response.dart';

class Category extends Response{
  String? id;

  Category({required super.status, super.error, this.id});
}