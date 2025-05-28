class user {
  String phone_number;
  String user_email;
  String user_id;
  String user_name;
  String user_role;

  user(
      {required this.phone_number,
      required this.user_email,
      required this.user_id,
      required this.user_name,
      required this.user_role});

  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      phone_number: json['phone_number'] ?? '',
      user_email: json['user_email'] ?? '',
      user_id: json['user_id'] ?? '',
      user_name: json['user_name'] ?? '',
      user_role: json['user_role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phone_number,
      'user_email': user_email,
      'user_id': user_id,
      'user_name': user_name,
      'user_role': user_role,
    };
  }
}
