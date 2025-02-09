class User {
  int? id;
  String? username;
  String? fullName;
  String? avatar;
  String? password;
  String? phone;
  String? email;
  String? role;

  DateTime? dob;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? modifiedAt;

  User(
      {this.id,
      this.username,
      this.fullName,
      this.avatar,
      this.password,
      this.phone,
      this.email,
      this.role,
      this.dob,
      this.isDeleted,
      this.createdAt,
      this.modifiedAt});
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ;
    username = json['username'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    password = json['password'];
    phone = json['phone'];
    email = json['email'];
    role = json['role'];

    dob = json['dob'] != null
        ? DateTime.parse(json['dob']) // Convert string to DateTime
        : null;
    isDeleted = json['isDeleted'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    modifiedAt =
        json['modifiedAt'] != null ? DateTime.parse(json['modifiedAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['role'] = this.role;
    data['dob'] = this.dob?.toIso8601String();
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt?.toIso8601String();
    data['modifiedAt'] = this.modifiedAt?.toIso8601String();
    return data;
  }
}
