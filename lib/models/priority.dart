
import 'package:note_management_system_v2/models/response.dart';

class PriorityModel{
  String? name;
  String? createdAt;
  String? user;

  PriorityModel({this.name, this.createdAt, this.user});

  factory PriorityModel.fromArray(List<dynamic> list) {
    return PriorityModel(
      name: list[0],
      user: list[1],
      createdAt: list[2],
    );
  }

}