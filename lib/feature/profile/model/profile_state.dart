import 'package:service_pro/feature/profile/model/user_profile_model.dart';

class ProfileState {
  final UserProfileModel user;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    required this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    UserProfileModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
