class RegisterRequest {
  int? id;
  String? username;
  String? fullName;
  String avatar; // Default value will be assigned directly
  String? password;
  String? phone;
  String? email;
  String role; // Default value will be assigned directly

  DateTime? dob;

  // Constructor with default values
  RegisterRequest({
    this.id,
    this.username,
    this.fullName,
    this.avatar = "default_avatar.png", // Default value
    this.password,
    this.phone,
    this.email,
    this.role = "ROLE_USER", // Default value
    this.dob,
  });

  // Convert RegisterRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'password': password,
      'phone': phone,
      'email': email,
      'role': role,
      'dob':
          dob?.toIso8601String(), // Convert DateTime to string if it's not null
    };
  }
}
