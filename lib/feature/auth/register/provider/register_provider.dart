import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/utils/token_storage.dart';
import 'package:service_pro/feature/auth/register/model/register_request_model.dart';
import 'package:service_pro/feature/auth/register/repository/register_repository.dart';

class RegisterProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    // Use repository with AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final repository = ref.read(registerRepositoryProvider);

      final request = RegisterRequestModel(
        name: name,
        email: email,
        password: password,
      );

      final response = await repository.register(request);
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (accessToken is String && accessToken.isNotEmpty) {
          await TokenStorage.saveAccessToken(accessToken);
        }

        if (refreshToken is String && refreshToken.isNotEmpty) {
          await TokenStorage.saveRefreshToken(refreshToken);
        }
      }
    });

    return !state.hasError;
  }
}

final registerProvider = AsyncNotifierProvider<RegisterProvider, void>(
  RegisterProvider.new,
);
