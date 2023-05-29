
import 'package:note_management_system_v2/models/response.dart';

class Category {
  String? name;
  String? createdAt;
  String? user;

  Category({this.name, this.createdAt, this.user});

  factory Category.fromArray(List<dynamic> list) {
    return Category(
      name: list[0],
      user: list[1],
      createdAt: list[2],
    );
  }
}