import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/utils/token_storage.dart';
import 'package:service_pro/feature/auth/login/model/login_request_model.dart';
import 'package:service_pro/feature/auth/login/repository/login_repository.dart';

class LoginProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    // Use repository with AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final repository = ref.read(loginRepositoryProvider);

      final request = LoginRequestModel(
        email: email,
        password: password,
      );

      final response = await repository.login(request);
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

final loginProvider =
    AsyncNotifierProvider<LoginProvider, void>(LoginProvider.new);
