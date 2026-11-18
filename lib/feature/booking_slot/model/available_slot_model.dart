class AvailableSlotModel {
  final String timeSlot;
  final bool isBooked;

  const AvailableSlotModel({
    required this.timeSlot,
    required this.isBooked,
  });

  bool get isAvailable => !isBooked;

  /// Returns true if the slot is a time range like "09:00 AM - 10:30 AM"
  bool get hasRange => timeSlot.contains(' - ');

  /// Start time portion, e.g. "09:00 AM"
  String get startTime {
    if (hasRange) {
      return timeSlot.split(' - ').first.trim();
    }
    return timeSlot.trim();
  }

  /// End time portion, e.g. "10:30 AM"
  String get endTime {
    if (hasRange) {
      final parts = timeSlot.split(' - ');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return '';
  }

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      timeSlot: json['timeSlot'] as String? ?? json['slot'] as String? ?? '',
      isBooked: json['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timeSlot': timeSlot,
      'isBooked': isBooked,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AvailableSlotModel &&
          runtimeType == other.runtimeType &&
          timeSlot == other.timeSlot &&
          isBooked == other.isBooked;

  @override
  int get hashCode => Object.hash(timeSlot, isBooked);
}

class AvailableSlotsResponseModel {
  final bool success;
  final String date;
  final String? serviceId;
  final List<AvailableSlotModel> slots;
  final String? message;

  const AvailableSlotsResponseModel({
    required this.success,
    required this.date,
    this.serviceId,
    required this.slots,
    this.message,
  });

  factory AvailableSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    final parsedSlots = <AvailableSlotModel>[];

    // Primary: Backend returns allSlots, bookedSlots, and availableSlots
    final hasAllSlots = json.containsKey('allSlots') && json['allSlots'] is List;
    final hasAvailableSlots = json.containsKey('availableSlots') && json['availableSlots'] is List;

    if (hasAllSlots || hasAvailableSlots) {
      final allSlotsRaw = (json['allSlots'] as List<dynamic>? ?? [])
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final bookedSlotsSet = (json['bookedSlots'] as List<dynamic>? ?? [])
          .map((e) => e.toString().trim())
          .toSet();

      final availableSlotsSet = (json['availableSlots'] as List<dynamic>? ?? [])
          .map((e) => e.toString().trim())
          .toSet();

      if (allSlotsRaw.isNotEmpty) {
        for (final slotStr in allSlotsRaw) {
          final isBooked = bookedSlotsSet.contains(slotStr) ||
              (availableSlotsSet.isNotEmpty && !availableSlotsSet.contains(slotStr));
          parsedSlots.add(AvailableSlotModel(
            timeSlot: slotStr,
            isBooked: isBooked,
          ));
        }
      } else {
        for (final slotStr in availableSlotsSet) {
          parsedSlots.add(AvailableSlotModel(
            timeSlot: slotStr,
            isBooked: false,
          ));
        }
        for (final slotStr in bookedSlotsSet) {
          if (!availableSlotsSet.contains(slotStr)) {
            parsedSlots.add(AvailableSlotModel(
              timeSlot: slotStr,
              isBooked: true,
            ));
          }
        }
      }
    }

    // Secondary: Object array format with "slots": [...]
    if (parsedSlots.isEmpty && json['slots'] is List) {
      final rawSlots = json['slots'] as List<dynamic>;
      for (final item in rawSlots) {
        if (item is Map<String, dynamic>) {
          parsedSlots.add(AvailableSlotModel.fromJson(item));
        } else if (item is String && item.trim().isNotEmpty) {
          parsedSlots.add(AvailableSlotModel(
            timeSlot: item.trim(),
            isBooked: false,
          ));
        }
      }
    }

    return AvailableSlotsResponseModel(
      success: json['success'] as bool? ?? true,
      date: json['date'] as String? ?? '',
      serviceId: json['serviceId'] as String?,
      slots: parsedSlots,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'date': date,
      if (serviceId != null) 'serviceId': serviceId,
      'slots': slots.map((s) => s.toJson()).toList(),
      if (message != null) 'message': message,
    };
  }
}
