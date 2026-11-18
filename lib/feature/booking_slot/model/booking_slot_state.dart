import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';

class BookingSlotState {
  final DateTime selectedDate;
  final AvailableSlotModel? selectedSlot;
  final List<AvailableSlotModel> slots;
  final String specialInstructions;
  final bool isSubmitting;
  final bool bookingSuccess;

  const BookingSlotState({
    required this.selectedDate,
    this.selectedSlot,
    this.slots = const [],
    this.specialInstructions = '',
    this.isSubmitting = false,
    this.bookingSuccess = false,
  });

  BookingSlotState copyWith({
    DateTime? selectedDate,
    AvailableSlotModel? selectedSlot,
    bool clearSelectedSlot = false,
    List<AvailableSlotModel>? slots,
    String? specialInstructions,
    bool? isSubmitting,
    bool? bookingSuccess,
  }) {
    return BookingSlotState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      slots: slots ?? this.slots,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
    );
  }
}
