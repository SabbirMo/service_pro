import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';

class AiRepository {
  final ApiServices _apiServices;

  AiRepository(this._apiServices);

  Future<String> sendChatMessage(String message) async {
    final response = await _apiServices.post(
      ApiEndPoints.aiChat,
      data: {'message': message},
      requireAuth: true,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['success'] == true && data['reply'] != null) {
        return data['reply'] as String;
      }
      if (data['message'] != null) {
        return data['message'] as String;
      }
    }

    throw Exception('Failed to receive response from AI Assistant.');
  }
}

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(ref.watch(apiServicesProvider));
});
