class NotificationBookingInfo {
  final String id;
  final String date;
  final String timeSlot;
  final String status;
  final double totalPrice;

  const NotificationBookingInfo({
    this.id = '',
    this.date = '',
    this.timeSlot = '',
    this.status = '',
    this.totalPrice = 0.0,
  });

  factory NotificationBookingInfo.fromJson(Map<String, dynamic> json) {
    return NotificationBookingInfo(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      timeSlot: (json['timeSlot'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'totalPrice': totalPrice,
    };
  }
}

class NotificationModel {
  final String id;
  final String user;
  final String recipientRole;
  final String title;
  final String message;
  final String? bookingId;
  final NotificationBookingInfo? booking;
  final String type;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationModel({
    required this.id,
    this.user = '',
    this.recipientRole = '',
    required this.title,
    required this.message,
    this.bookingId,
    this.booking,
    this.type = 'GENERAL',
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  String get timeAgo {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final month = monthNames[createdAt!.month - 1];
      return '$month ${createdAt!.day}';
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    String? extractedBookingId;
    NotificationBookingInfo? bookingInfo;

    final rawBooking = json['bookingId'];
    if (rawBooking is Map<String, dynamic>) {
      bookingInfo = NotificationBookingInfo.fromJson(rawBooking);
      extractedBookingId = bookingInfo.id;
    } else if (rawBooking is String) {
      extractedBookingId = rawBooking;
    }

    return NotificationModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      user: (json['user'] ?? '').toString(),
      recipientRole: (json['recipientRole'] ?? '').toString(),
      title: (json['title'] ?? 'Notification').toString(),
      message: (json['message'] ?? '').toString(),
      bookingId: extractedBookingId,
      booking: bookingInfo,
      type: (json['type'] ?? 'GENERAL').toString(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())?.toLocal()
          : null,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? user,
    String? recipientRole,
    String? title,
    String? message,
    String? bookingId,
    NotificationBookingInfo? booking,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      recipientRole: recipientRole ?? this.recipientRole,
      title: title ?? this.title,
      message: message ?? this.message,
      bookingId: bookingId ?? this.bookingId,
      booking: booking ?? this.booking,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'recipientRole': recipientRole,
      'title': title,
      'message': message,
      if (booking != null)
        'bookingId': booking!.toJson()
      else if (bookingId != null)
        'bookingId': bookingId,
      'type': type,
      'isRead': isRead,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

class NotificationResponseModel {
  final bool success;
  final int unreadCount;
  final List<NotificationModel> notifications;

  const NotificationResponseModel({
    required this.success,
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['notifications'] as List? ?? [];
    final list = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => NotificationModel.fromJson(e))
        .toList();

    return NotificationResponseModel(
      success: json['success'] as bool? ?? true,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ??
          list.where((n) => !n.isRead).length,
      notifications: list,
    );
  }
}
