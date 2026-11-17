import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/auth/register/model/register_state.dart';

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void passwordToggle() {
    state = state.copyWith(password: !state.password);
  }
}

final registerNotifierProvider =
    NotifierProvider.autoDispose<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);
