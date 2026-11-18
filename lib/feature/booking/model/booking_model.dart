import 'package:flutter/material.dart';

class BookingServiceModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int durationMinutes;
  final String image;
  final String description;
  final double rating;

  const BookingServiceModel({
    this.id = '',
    this.name = '',
    this.category = '',
    this.price = 0.0,
    this.durationMinutes = 0,
    this.image = '',
    this.description = '',
    this.rating = 0.0,
  });

  factory BookingServiceModel.fromJson(dynamic json) {
    if (json is String) {
      return BookingServiceModel(id: json);
    }
    if (json is! Map<String, dynamic>) {
      return const BookingServiceModel();
    }

    return BookingServiceModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      image: (json['image'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'category': category,
      'price': price,
      'durationMinutes': durationMinutes,
      'image': image,
      'description': description,
      'rating': rating,
    };
  }
}

class BookingUserModel {
  final String id;
  final String name;
  final String email;
  final String address;

  const BookingUserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.address = '',
  });

  factory BookingUserModel.fromJson(dynamic json) {
    if (json is String) {
      return BookingUserModel(id: json);
    }
    if (json is! Map<String, dynamic>) {
      return const BookingUserModel();
    }

    return BookingUserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }
}

class BookingModel {
  final String id;
  final BookingServiceModel service;
  final BookingUserModel? user;
  final String date;
  final String timeSlot;
  final String address;
  final String notes;
  final double totalPrice;
  final String status;
  final DateTime? createdAt;

  const BookingModel({
    required this.id,
    required this.service,
    this.user,
    required this.date,
    required this.timeSlot,
    required this.address,
    this.notes = '',
    required this.totalPrice,
    required this.status,
    this.createdAt,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get canCancel => isPending;

  // Status Styling according to specs:
  // Pending: amber #FEF3C7 / #D97706
  // Confirmed: blue #DBEAFE / #1D4ED8
  // Completed: green #D1FAE5 / #047857
  // Cancelled: red #FEE2E2 / #DC2626
  Color get statusBgColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'confirmed':
        return const Color(0xFFDBEAFE);
      case 'completed':
        return const Color(0xFFD1FAE5);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color get statusTextColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD97706);
      case 'confirmed':
        return const Color(0xFF1D4ED8);
      case 'completed':
        return const Color(0xFF047857);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF475569);
    }
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      service: BookingServiceModel.fromJson(json['service']),
      user: json['user'] != null ? BookingUserModel.fromJson(json['user']) : null,
      date: (json['date'] ?? '').toString(),
      timeSlot: (json['timeSlot'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      status: (json['status'] ?? 'Pending').toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  BookingModel copyWith({
    String? id,
    BookingServiceModel? service,
    BookingUserModel? user,
    String? date,
    String? timeSlot,
    String? address,
    String? notes,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      service: service ?? this.service,
      user: user ?? this.user,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service': service.toJson(),
      if (user != null) 'user': user!.toJson(),
      'date': date,
      'timeSlot': timeSlot,
      'address': address,
      'notes': notes,
      'totalPrice': totalPrice,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}

class MyBookingsResponseModel {
  final bool success;
  final int count;
  final List<BookingModel> bookings;

  const MyBookingsResponseModel({
    required this.success,
    required this.count,
    required this.bookings,
  });

  factory MyBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['bookings'] as List? ?? [];
    final list = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => BookingModel.fromJson(e))
        .toList();

    return MyBookingsResponseModel(
      success: json['success'] as bool? ?? true,
      count: (json['count'] as num?)?.toInt() ?? list.length,
      bookings: list,
    );
  }
}

class SingleBookingResponseModel {
  final bool success;
  final BookingModel booking;

  const SingleBookingResponseModel({
    required this.success,
    required this.booking,
  });

  factory SingleBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return SingleBookingResponseModel(
      success: json['success'] as bool? ?? true,
      booking: BookingModel.fromJson(
        json['booking'] as Map<String, dynamic>? ?? json,
      ),
    );
  }
}
