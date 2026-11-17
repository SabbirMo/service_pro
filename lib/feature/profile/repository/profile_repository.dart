import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/profile/model/change_password_request_model.dart';
import 'package:service_pro/feature/profile/model/edit_profile_request_model.dart';
import 'package:service_pro/feature/profile/model/user_profile_model.dart';

class ProfileRepository {
  final ApiServices _apiServices;

  ProfileRepository(this._apiServices);

  /// Fetch user profile: GET /api/users/me
  Future<UserProfileModel> getUserProfile() async {
    final response = await _apiServices.get(
      ApiEndPoints.userProfile,
      requireAuth: true,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final userMap = (data['user'] is Map<String, dynamic>)
          ? data['user'] as Map<String, dynamic>
          : data;

      return UserProfileModel.fromJson(userMap);
    }

    throw Exception('Invalid profile data format');
  }

  /// Update name, image, and address: PUT /api/users/edit-profile
  Future<UserProfileModel> editProfile(EditProfileRequestModel request) async {
    final response = await _apiServices.put(
      ApiEndPoints.editProfile,
      data: request.toJson(),
      requireAuth: true,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final userMap = (data['user'] is Map<String, dynamic>)
          ? data['user'] as Map<String, dynamic>
          : data;

      return UserProfileModel.fromJson(userMap);
    }

    throw Exception('Invalid profile update response');
  }

  /// Change password: PUT /api/users/change-password
  Future<Response> changePassword(ChangePasswordRequestModel request) async {
    return await _apiServices.put(
      ApiEndPoints.changePassword,
      data: request.toJson(),
      requireAuth: true,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(apiServicesProvider)),
);
