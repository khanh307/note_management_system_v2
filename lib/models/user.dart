class User {
  String? email;
  String? firstname;
  String? lastname;
  int? status;
  int? error;
  Map<String, dynamic>? info;

  User({this.email, this.firstname, this.lastname, this.status, this.error, this.info});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      status: json['status'],
      error: json['error'],
      info: json['info'],
    );
  }

}
