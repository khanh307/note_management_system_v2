import 'package:note_management_system_v2/models/response.dart';

class Status {
  String? name;
  String? createdAt;
  String? user;

  Status({this.name, this.createdAt, this.user});

  factory Status.fromArray(List<dynamic> list) {
    return Status(
      name: list[0],
      user: list[1],
      createdAt: list[2],
    );
  }
}
