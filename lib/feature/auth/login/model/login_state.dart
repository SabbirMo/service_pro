class LoginState {
  final bool password;

  const LoginState({this.password = false});

  LoginState copyWith({bool? password}) {
    return LoginState(password: password ?? this.password);
  }
}
