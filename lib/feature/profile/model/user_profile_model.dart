class UserProfileModel {
  final String? id;
  final String name;
  final String email;
  final String address;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  const UserProfileModel({
    this.id,
    required this.name,
    required this.email,
    required this.address,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Backward compatibility with existing UI code
  String? get imagePath => image;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      image: (json['image'] != null && json['image'].toString().isNotEmpty)
          ? json['image'].toString()
          : null,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'address': address,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? image,
    String? imagePath,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      image: image ?? imagePath ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
