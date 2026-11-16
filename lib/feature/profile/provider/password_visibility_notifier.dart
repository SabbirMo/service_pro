import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibilityState {
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;

  const PasswordVisibilityState({
    this.obscureCurrent = false,
    this.obscureNew = false,
    this.obscureConfirm = false,
  });

  PasswordVisibilityState copyWith({
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
  }) {
    return PasswordVisibilityState(
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
    );
  }
}

class PasswordVisibilityNotifier extends Notifier<PasswordVisibilityState> {
  @override
  PasswordVisibilityState build() => const PasswordVisibilityState();

  void toggleCurrent() {
    state = state.copyWith(obscureCurrent: !state.obscureCurrent);
  }

  void toggleNew() {
    state = state.copyWith(obscureNew: !state.obscureNew);
  }

  void toggleConfirm() {
    state = state.copyWith(obscureConfirm: !state.obscureConfirm);
  }
}

final passwordVisibilityProvider =
    NotifierProvider.autoDispose<
      PasswordVisibilityNotifier,
      PasswordVisibilityState
    >(PasswordVisibilityNotifier.new);
