import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';
import 'package:service_pro/feature/profile/model/change_password_request_model.dart';
import 'package:service_pro/feature/profile/model/edit_profile_request_model.dart';
import 'package:service_pro/feature/profile/model/profile_state.dart';
import 'package:service_pro/feature/profile/model/user_profile_model.dart';
import 'package:service_pro/feature/profile/repository/profile_repository.dart';

class ProfileNotifier extends Notifier<ProfileState> {
  late final ProfileRepository _repository;

  @override
  ProfileState build() {
    _repository = ref.watch(profileRepositoryProvider);

    // Fetch user profile on startup
    Future.microtask(() => fetchUserProfile());

    return const ProfileState(
      user: UserProfileModel(name: "", email: "", address: ""),
      isLoading: true,
    );
  }

  /// Fetch user profile: GET /api/users/me
  Future<void> fetchUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repository.getUserProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Update name, image, and address: PUT /api/users/edit-profile
  Future<bool> editProfile({
    required String name,
    required String address,
    String? image,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = EditProfileRequestModel(
        name: name,
        address: address,
        image: image,
      );

      final updatedUser = await _repository.editProfile(request);
      state = state.copyWith(user: updatedUser, isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Change password: PUT /api/users/change-password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = ChangePasswordRequestModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      await _repository.changePassword(request);
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);
