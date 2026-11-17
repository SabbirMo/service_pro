import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/home/model/services_response_model.dart';

class HomeRepository {
  final ApiServices _apiServices;

  HomeRepository(this._apiServices);

  Future<ServicesResponseModel> getServices({
    bool? featured,
    String? category,
    String? search,
    int? page,
    int? limit,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (featured == true) {
      queryParameters['featured'] = 'true';
    }

    if (category != null && category.trim().isNotEmpty && category != 'All') {
      queryParameters['category'] = category.trim();
    }

    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    if (page != null) {
      queryParameters['page'] = page;
    }

    if (limit != null) {
      queryParameters['limit'] = limit;
    }

    final response = await _apiServices.get(
      ApiEndPoints.services,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      requireAuth: false,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ServicesResponseModel.fromJson(data);
    }

    throw Exception('Invalid services response format');
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiServicesProvider));
});
