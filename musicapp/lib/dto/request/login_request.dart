class LoginRequest {
  String? username;
  String? password;

  LoginRequest({required this.username, required this.password});
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
