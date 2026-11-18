import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/notification/model/notification_model.dart';

class NotificationRepository {
  final ApiServices _apiServices;

  NotificationRepository(this._apiServices);

  /// Fetch all notifications: GET /api/notifications
  Future<NotificationResponseModel> getNotifications() async {
    final response = await _apiServices.get<Map<String, dynamic>>(
      ApiEndPoints.notifications,
      requireAuth: true,
    );

    return NotificationResponseModel.fromJson(response.data ?? {});
  }

  /// Mark single notification as read: PATCH /api/notifications/:id/read
  Future<Map<String, dynamic>> markAsRead(String id) async {
    final response = await _apiServices.patch<Map<String, dynamic>>(
      ApiEndPoints.markNotificationAsRead(id),
      requireAuth: true,
    );

    return response.data ?? {'success': true};
  }

  /// Mark all notifications as read: PATCH /api/notifications/read-all
  Future<Map<String, dynamic>> markAllAsRead() async {
    final response = await _apiServices.patch<Map<String, dynamic>>(
      ApiEndPoints.markAllNotificationsAsRead,
      requireAuth: true,
    );

    return response.data ?? {'success': true};
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(apiServicesProvider));
});
