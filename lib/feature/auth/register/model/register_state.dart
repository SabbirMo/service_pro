class RegisterState {
  final bool password;
  final bool isLoading;

  const RegisterState({
    this.password = false,
    this.isLoading = false,
  });

  RegisterState copyWith({
    bool? password,
    bool? isLoading,
  }) {
    return RegisterState(
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
