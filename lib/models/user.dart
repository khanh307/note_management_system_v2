class User {
  String? email;
  String? password;
  String? firstname;
  String? lastname;

  User({this.email, this.password, this.firstname, this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
