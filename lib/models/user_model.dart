class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String businessCategory;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessCategory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      businessName: json['businessName'] ?? '', 
      businessCategory: json['businessCategory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'businessName': businessName,
      'businessCategory': businessCategory,
    };
  }
}