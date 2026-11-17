class RegisterState {
  final bool password;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isSuccess;

  const RegisterState({
    this.password = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isSuccess = false,
  });

  RegisterState copyWith({
    bool? password,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isSuccess,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return RegisterState(
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
