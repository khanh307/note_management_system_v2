class DashboardModel {
  String? name;
  String? counter;

  DashboardModel({this.name, this.counter});

  factory DashboardModel.fromArray(List<dynamic> list) {
    return DashboardModel(
      name: list[0],
      counter: list[1],
    );
  }
}
