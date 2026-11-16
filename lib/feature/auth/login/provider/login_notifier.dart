import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/auth/login/model/login_state.dart';

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => LoginState();

  void passwordToggle() {
    state = state.copyWith(password: !state.password);
  }
}

final loginNotifierProvider =
    NotifierProvider.autoDispose<LoginNotifier, LoginState>(LoginNotifier.new);
