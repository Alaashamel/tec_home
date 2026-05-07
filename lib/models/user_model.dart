class UserModel {
  String email;
  String password;
  String name;

  UserModel({
    required this.email,
    required this.password,
    this.name = "",
  });
}