import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/auth/login/model/login_request_model.dart';

class LoginRepository {
  final ApiServices _apiServices;

  LoginRepository(this._apiServices);

  Future<Response> login(LoginRequestModel request) async {
    return await _apiServices.post(
      ApiEndPoints.login,
      data: request.toJson(),
      requireAuth: false,
    );
  }
}

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => LoginRepository(ref.watch(apiServicesProvider)),
);
