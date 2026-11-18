import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';
import 'package:service_pro/feature/booking_slot/model/booking_slot_state.dart';
import 'package:service_pro/feature/booking_slot/repository/booking_slot_repository.dart';

class BookingSlotNotifier extends AsyncNotifier<BookingSlotState> {
  final String serviceId;

  BookingSlotNotifier(this.serviceId);

  BookingSlotRepository get _repository =>
      ref.read(bookingSlotRepositoryProvider);

  @override
  FutureOr<BookingSlotState> build() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year, now.month, now.day);

    final response = await _repository.getAvailableSlots(
      serviceId: serviceId,
      date: initialDate,
    );

    return BookingSlotState(selectedDate: initialDate, slots: response.slots);
  }

  /// Change selected date and immediately fetch new slots
  Future<void> changeDate(DateTime date) async {
    final current = state.value;
    if (current != null &&
        current.selectedDate.year == date.year &&
        current.selectedDate.month == date.month &&
        current.selectedDate.day == date.day) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await _repository.getAvailableSlots(
        serviceId: serviceId,
        date: date,
      );

      return (current ?? BookingSlotState(selectedDate: date)).copyWith(
        selectedDate: date,
        slots: response.slots,
        clearSelectedSlot: true,
      );
    });
  }

  /// Retry fetching slots
  Future<void> retry() async {
    final targetDate = state.value?.selectedDate ?? DateTime.now();
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await _repository.getAvailableSlots(
        serviceId: serviceId,
        date: targetDate,
      );

      return (state.value ?? BookingSlotState(selectedDate: targetDate))
          .copyWith(selectedDate: targetDate, slots: response.slots);
    });
  }

  /// Select a time slot (only if not already booked)
  void selectSlot(AvailableSlotModel slot) {
    if (slot.isBooked) return;
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedSlot: slot));
  }

  /// Update special instructions
  void setSpecialInstructions(String instructions) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(specialInstructions: instructions));
  }

  /// Submit / Confirm booking
  Future<bool> confirmBooking() async {
    final current = state.value;
    if (current == null || current.selectedSlot == null) return false;

    state = AsyncData(current.copyWith(isSubmitting: true));

    try {
      await _repository.createBooking(
        serviceId: serviceId,
        date: current.selectedDate,
        timeSlot: current.selectedSlot!.timeSlot,
        specialInstructions: current.specialInstructions,
      );

      state = AsyncData(
        current.copyWith(isSubmitting: false, bookingSuccess: true),
      );
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(isSubmitting: false));
      rethrow;
    }
  }
}

final bookingSlotNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<BookingSlotNotifier, BookingSlotState, String>(
      (serviceId) => BookingSlotNotifier(serviceId),
    );
