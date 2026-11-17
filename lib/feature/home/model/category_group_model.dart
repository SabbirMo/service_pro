import 'package:service_pro/feature/home/model/service_model.dart';

class CategoryGroupModel {
  final String category;
  final List<ServiceModel> services;

  const CategoryGroupModel({
    required this.category,
    required this.services,
  });

  factory CategoryGroupModel.fromJson(Map<String, dynamic> json) {
    return CategoryGroupModel(
      category: json['category'] as String? ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'services': services.map((s) => s.toJson()).toList(),
    };
  }
}
