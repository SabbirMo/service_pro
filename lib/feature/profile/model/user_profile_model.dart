class UserProfileModel {
  final String name;
  final String email;
  final String address;
  final String? imagePath;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.address,
    this.imagePath,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? address,
    String? imagePath,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
