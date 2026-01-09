class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int role;
  final String? profileImage;
  final bool isVerified;
  final Map<String, dynamic>? roleSpecificData;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    this.profileImage,
    this.isVerified = false,
    this.roleSpecificData,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      role: json['role'] ?? 1,
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
      roleSpecificData: json['roleSpecificData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'profileImage': profileImage,
      'isVerified': isVerified,
      'roleSpecificData': roleSpecificData,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    int? role,
    String? profileImage,
    bool? isVerified,
    Map<String, dynamic>? roleSpecificData,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      roleSpecificData: roleSpecificData ?? this.roleSpecificData,
    );
  }
}
