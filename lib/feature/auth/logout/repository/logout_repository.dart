import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';

class LogoutRepository {
  final ApiServices _apiServices;

  LogoutRepository(this._apiServices);

  Future<void> logout() async {
    await _apiServices.post(ApiEndPoints.logout);
  }
}

final logoutRepositoryProvider = Provider<LogoutRepository>(
  (ref) => LogoutRepository(ref.watch(apiServicesProvider)),
);
