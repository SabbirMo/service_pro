import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';
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

  /// Update service address
  void setAddress(String address) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(address: address));
  }

  /// Update notes / special instructions
  void setNotes(String notes) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(notes: notes));
  }

  /// Submit / Confirm booking: POST /api/bookings
  Future<({bool success, String? message, String? bookingId})> confirmBooking({
    required String address,
    String? notes,
  }) async {
    final current = state.value;
    if (current == null || current.selectedSlot == null) {
      return (
        success: false,
        message: 'Please select an available time slot.',
        bookingId: null,
      );
    }

    state = AsyncData(current.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    ));

    try {
      final res = await _repository.createBooking(
        serviceId: serviceId,
        date: current.selectedDate,
        timeSlot: current.selectedSlot!.timeSlot,
        address: address,
        notes: notes ?? current.notes,
      );

      final bookingMap = res['booking'] as Map<String, dynamic>?;
      final bookingId = bookingMap?['_id']?.toString() ??
          bookingMap?['id']?.toString() ??
          res['bookingId']?.toString();

      // Refresh slots from server so newly booked slot is marked booked
      final updatedResponse = await _repository.getAvailableSlots(
        serviceId: serviceId,
        date: current.selectedDate,
      );

      state = AsyncData(
        current.copyWith(
          slots: updatedResponse.slots,
          address: address,
          notes: notes ?? current.notes,
          isSubmitting: false,
          bookingSuccess: true,
          clearSelectedSlot: true,
          clearErrorMessage: true,
        ),
      );

      // Invalidate and refresh all bookings so Upcoming tab immediately has the new booking
      try {
        ref.read(bookingNotifierProvider.notifier).loadAll(showLoader: false);
      } catch (_) {}

      return (success: true, message: null, bookingId: bookingId);
    } on ApiException catch (e) {
      // If server returns an error (e.g. "This time slot is already booked..."),
      // immediately refresh slots from server to update booked status in UI
      try {
        final updatedResponse = await _repository.getAvailableSlots(
          serviceId: serviceId,
          date: current.selectedDate,
        );
        state = AsyncData(current.copyWith(
          slots: updatedResponse.slots,
          isSubmitting: false,
          errorMessage: e.message,
          clearSelectedSlot: true,
        ));
      } catch (_) {
        state = AsyncData(current.copyWith(
          isSubmitting: false,
          errorMessage: e.message,
        ));
      }
      return (success: false, message: e.message, bookingId: null);
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AsyncData(current.copyWith(
        isSubmitting: false,
        errorMessage: msg,
      ));
      return (success: false, message: msg, bookingId: null);
    }
  }
}

final bookingSlotNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<BookingSlotNotifier, BookingSlotState, String>(
      (serviceId) => BookingSlotNotifier(serviceId),
    );
