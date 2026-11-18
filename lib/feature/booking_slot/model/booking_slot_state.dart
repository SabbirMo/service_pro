import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';

class BookingSlotState {
  final DateTime selectedDate;
  final AvailableSlotModel? selectedSlot;
  final List<AvailableSlotModel> slots;
  final String address;
  final String notes;
  final bool isSubmitting;
  final bool bookingSuccess;
  final String? errorMessage;

  const BookingSlotState({
    required this.selectedDate,
    this.selectedSlot,
    this.slots = const [],
    this.address = '',
    this.notes = '',
    this.isSubmitting = false,
    this.bookingSuccess = false,
    this.errorMessage,
  });

  BookingSlotState copyWith({
    DateTime? selectedDate,
    AvailableSlotModel? selectedSlot,
    bool clearSelectedSlot = false,
    List<AvailableSlotModel>? slots,
    String? address,
    String? notes,
    bool? isSubmitting,
    bool? bookingSuccess,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BookingSlotState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      slots: slots ?? this.slots,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
