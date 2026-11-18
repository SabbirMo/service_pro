import 'package:flutter_test/flutter_test.dart';
import 'package:service_pro/feature/notification/model/notification_model.dart';
import 'package:service_pro/feature/notification/provider/notification_notifier.dart';

void main() {
  group('NotificationModel & Response Tests', () {
    test('NotificationModel parses populated bookingId object correctly', () {
      final json = {
        "_id": "65f0123456789abcdef00101",
        "user": "65e0123456789abcdef00002",
        "recipientRole": "admin",
        "title": "New Booking Request! 🔔",
        "message": "Rahim Ahmed booked Plumbing Repair on 2026-11-22 at 10:00 AM - 11:30 AM.",
        "bookingId": {
          "_id": "65f0123456789abcdef00201",
          "date": "2026-11-22",
          "timeSlot": "10:00 AM - 11:30 AM",
          "status": "Pending",
          "totalPrice": 45
        },
        "type": "BOOKING",
        "isRead": false,
        "createdAt": "2026-11-18T15:00:00.000Z",
        "updatedAt": "2026-11-18T15:00:00.000Z"
      };

      final notification = NotificationModel.fromJson(json);

      expect(notification.id, "65f0123456789abcdef00101");
      expect(notification.user, "65e0123456789abcdef00002");
      expect(notification.recipientRole, "admin");
      expect(notification.title, "New Booking Request! 🔔");
      expect(notification.type, "BOOKING");
      expect(notification.isRead, false);
      expect(notification.bookingId, "65f0123456789abcdef00201");
      expect(notification.booking?.date, "2026-11-22");
      expect(notification.booking?.timeSlot, "10:00 AM - 11:30 AM");
      expect(notification.booking?.status, "Pending");
      expect(notification.booking?.totalPrice, 45.0);
    });

    test('NotificationModel parses string bookingId correctly', () {
      final json = {
        "_id": "65f0123456789abcdef00102",
        "user": "65e0123456789abcdef00002",
        "recipientRole": "admin",
        "title": "New Booking Request! 🔔",
        "message": "Karim booked AC Cleaning on 2026-11-21 at 02:00 PM - 03:30 PM.",
        "bookingId": "65f0123456789abcdef00202",
        "type": "BOOKING",
        "isRead": true,
        "createdAt": "2026-11-18T14:30:00.000Z",
        "updatedAt": "2026-11-18T14:35:00.000Z"
      };

      final notification = NotificationModel.fromJson(json);

      expect(notification.id, "65f0123456789abcdef00102");
      expect(notification.bookingId, "65f0123456789abcdef00202");
      expect(notification.booking, isNull);
      expect(notification.isRead, true);
    });

    test('NotificationResponseModel parses response with unread count and list', () {
      final json = {
        "success": true,
        "unreadCount": 2,
        "notifications": [
          {
            "_id": "1",
            "title": "Alert 1",
            "message": "Message 1",
            "type": "BOOKING",
            "isRead": false
          },
          {
            "_id": "2",
            "title": "Alert 2",
            "message": "Message 2",
            "type": "GENERAL",
            "isRead": true
          }
        ]
      };

      final response = NotificationResponseModel.fromJson(json);

      expect(response.success, true);
      expect(response.unreadCount, 2);
      expect(response.notifications.length, 2);
      expect(response.notifications[0].title, "Alert 1");
      expect(response.notifications[1].title, "Alert 2");
    });

    test('NotificationState copyWith updates properly', () {
      const state = NotificationState(unreadCount: 3, isLoading: true);
      final updated = state.copyWith(unreadCount: 2, isLoading: false);

      expect(updated.unreadCount, 2);
      expect(updated.isLoading, false);
    });
  });
}
