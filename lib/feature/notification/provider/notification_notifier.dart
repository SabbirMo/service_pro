import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';
import 'package:service_pro/feature/notification/model/notification_model.dart';
import 'package:service_pro/feature/notification/repository/notification_repository.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isMarkingAllRead;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isMarkingAllRead = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isMarkingAllRead,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  @override
  NotificationState build() {
    Future.microtask(() => fetchNotifications());
    return const NotificationState(isLoading: true);
  }

  /// Fetch all notifications & unread count: GET /api/notifications
  Future<void> fetchNotifications({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(isLoading: true, clearErrorMessage: true);
    }

    try {
      final response = await _repository.getNotifications();
      state = state.copyWith(
        notifications: response.notifications,
        unreadCount: response.unreadCount,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Mark single notification as read: PATCH /api/notifications/:id/read
  Future<bool> markAsRead(String id) async {
    final index = state.notifications.indexWhere((n) => n.id == id);
    if (index == -1) return false;

    final target = state.notifications[index];
    if (target.isRead) return true; // Already read

    // Optimistic UI update
    final updatedList = List<NotificationModel>.from(state.notifications);
    updatedList[index] = target.copyWith(isRead: true);

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: max(0, state.unreadCount - 1),
    );

    try {
      await _repository.markAsRead(id);
      return true;
    } catch (_) {
      // Re-fetch on failure to sync
      fetchNotifications(showLoader: false);
      return false;
    }
  }

  /// Mark all notifications as read: PATCH /api/notifications/read-all
  Future<bool> markAllAsRead() async {
    if (state.unreadCount == 0) return true;

    // Optimistic UI update
    final currentList = state.notifications;
    final updatedList = currentList.map((n) => n.copyWith(isRead: true)).toList();

    state = state.copyWith(
      notifications: updatedList,
      unreadCount: 0,
      isMarkingAllRead: true,
    );

    try {
      await _repository.markAllAsRead();
      state = state.copyWith(isMarkingAllRead: false);
      return true;
    } catch (e) {
      state = state.copyWith(isMarkingAllRead: false);
      // Re-fetch to sync
      fetchNotifications(showLoader: false);
      return false;
    }
  }
}

final notificationNotifierProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);
