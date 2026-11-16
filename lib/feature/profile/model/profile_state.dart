import 'package:service_pro/feature/profile/model/user_profile_model.dart';

class ProfileState {
  final UserProfileModel user;
  final bool isLoading;

  const ProfileState({
    required this.user,
    this.isLoading = false,
  });

  ProfileState copyWith({
    UserProfileModel? user,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
