import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      await repository.register(request);
    });

    return !state.hasError;
  }
}

final registerProvider =
    AsyncNotifierProvider<RegisterProvider, void>(RegisterProvider.new);
