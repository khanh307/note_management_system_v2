import 'package:note_management_system_v2/models/response.dart';

class Note {
  String? name;
  String? category;
  String? status;
  String? priority;
  String? planDate;
  String? createdAt;
  String? user;

  Note(
      {this.name,
      this.category,
      this.status,
      this.priority,
      this.planDate,
      this.createdAt,
      this.user});

  factory Note.fromArray(List<dynamic> list) {
    return Note(
      name: list[0],
      category: list[1],
      priority: list[2],
      status: list[3],
      planDate: list[4],
      createdAt: list[6],
      user: list[5],
    );
  }
}
