class User {
  int id;
  String username;
  String firstName;
  String lastName;
  String? phone;
  String? email;
  String? facebookId;
  String? appleId;
  String? googleId;
  bool isEmailVerified;
  bool isPhoneVerified;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.facebookId,
    required this.appleId,
    required this.googleId,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      phone: json['phone'],
      email: json['email'],
      facebookId: json['facebookId'],
      appleId: json['appleId'],
      googleId: json['googleId'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['facebookId'] = facebookId;
    data['appleId'] = appleId;
    data['googleId'] = googleId;
    data['isEmailVerified'] = isEmailVerified;
    data['isPhoneVerified'] = isPhoneVerified;

    return data;
  }
}
