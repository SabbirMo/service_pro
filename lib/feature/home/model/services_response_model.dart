import 'package:service_pro/feature/home/model/category_group_model.dart';
import 'package:service_pro/feature/home/model/pagination_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';

class ServicesResponseModel {
  final bool success;
  final int count;
  final PaginationModel pagination;
  final List<CategoryGroupModel> data;

  const ServicesResponseModel({
    required this.success,
    required this.count,
    this.pagination = const PaginationModel(),
    required this.data,
  });

  factory ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return ServicesResponseModel(
      success: json['success'] as bool? ?? false,
      count: json['count'] as int? ?? 0,
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : const PaginationModel(),
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryGroupModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Flattens all services across all category groups
  List<ServiceModel> get allServices {
    return data.expand((group) => group.services).toList();
  }
}
