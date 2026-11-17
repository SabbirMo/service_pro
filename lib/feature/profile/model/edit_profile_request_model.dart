class EditProfileRequestModel {
  final String name;
  final String? image;
  final String address;

  const EditProfileRequestModel({
    required this.name,
    this.image,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image ?? '',
      'address': address,
    };
  }

  factory EditProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return EditProfileRequestModel(
      name: json['name'] ?? '',
      image: json['image'],
      address: json['address'] ?? '',
    );
  }
}
