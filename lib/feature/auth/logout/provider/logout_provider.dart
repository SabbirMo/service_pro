import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/utils/token_storage.dart';
import 'package:service_pro/feature/auth/logout/repository/logout_repository.dart';

class LogoutProvider extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> logout() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(logoutRepositoryProvider);
      await repository.logout();
      await TokenStorage.clearTokens();
    });

    return !state.hasError;
  }
}

final logoutProvider = AsyncNotifierProvider<LogoutProvider, void>(
  LogoutProvider.new,
);
