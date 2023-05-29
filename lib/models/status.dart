
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
