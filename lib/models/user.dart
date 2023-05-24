class User {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  User({this.id, this.email, this.password, this.firstname, this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
