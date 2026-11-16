import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/profile/model/profile_state.dart';
import 'package:service_pro/feature/profile/model/user_profile_model.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState(
      user: UserProfileModel(
        name: "Sabbir Ahmed",
        email: "sabbir.dev@example.com",
        address: "Dhanmondi 27, Dhaka, Bangladesh",
      ),
    );
  }

  void updatePersonalInfo({
    required String name,
    required String address,
    String? imagePath,
  }) {
    state = state.copyWith(
      user: state.user.copyWith(
        name: name,
        address: address,
        imagePath: imagePath ?? state.user.imagePath,
      ),
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(isLoading: false);
    return true;
  }
}

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
