import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/auth/register/model/register_request_model.dart';

class RegisterRepository {
  final ApiServices _apiServices;

  RegisterRepository(this._apiServices);

  Future<Response> register(RegisterRequestModel request) async {
    return await _apiServices.post(
      ApiEndPoints.register,
      data: request.toJson(),
      requireAuth: false,
    );
  }
}

final registerRepositoryProvider = Provider<RegisterRepository>(
  (ref) => RegisterRepository(ref.watch(apiServicesProvider)),
);
