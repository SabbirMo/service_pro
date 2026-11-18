import 'package:flutter_test/flutter_test.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';
import 'package:service_pro/feature/booking_slot/model/booking_slot_state.dart';
import 'package:service_pro/feature/booking_slot/repository/booking_slot_repository.dart';

void main() {
  group('Booking Slot Models & Repository Tests', () {
    test('AvailableSlotModel parses json and range helpers correctly', () {
      final json = {
        'timeSlot': '09:00 AM - 10:30 AM',
        'isBooked': false,
      };

      final model = AvailableSlotModel.fromJson(json);

      expect(model.timeSlot, '09:00 AM - 10:30 AM');
      expect(model.isBooked, false);
      expect(model.isAvailable, true);
      expect(model.hasRange, true);
      expect(model.startTime, '09:00 AM');
      expect(model.endTime, '10:30 AM');
    });

    test('AvailableSlotsResponseModel parses real backend response with allSlots and availableSlots correctly', () {
      final json = {
        "success": true,
        "serviceId": "6afd32d05cead3d7ed869b00",
        "date": "2026-11-18",
        "allSlots": [
          "09:00 AM - 10:30 AM",
          "10:30 AM - 12:00 PM",
          "12:00 PM - 01:30 PM",
          "02:00 PM - 03:30 PM",
          "03:30 PM - 05:00 PM",
          "05:00 PM - 06:30 PM"
        ],
        "bookedSlots": ["12:00 PM - 01:30 PM"],
        "availableSlots": [
          "09:00 AM - 10:30 AM",
          "10:30 AM - 12:00 PM",
          "02:00 PM - 03:30 PM",
          "03:30 PM - 05:00 PM",
          "05:00 PM - 06:30 PM"
        ]
      };

      final response = AvailableSlotsResponseModel.fromJson(json);

      expect(response.success, true);
      expect(response.date, '2026-11-18');
      expect(response.serviceId, '6afd32d05cead3d7ed869b00');
      expect(response.slots.length, 6);
      expect(response.slots[0].timeSlot, '09:00 AM - 10:30 AM');
      expect(response.slots[0].isBooked, false);
      expect(response.slots[2].timeSlot, '12:00 PM - 01:30 PM');
      expect(response.slots[2].isBooked, true);
    });

    test('BookingSlotRepository.formatDate formats date to yyyy-MM-dd correctly', () {
      final date = DateTime(2026, 11, 18);
      final formatted = BookingSlotRepository.formatDate(date);
      expect(formatted, '2026-11-18');
    });

    test('BookingSlotState copyWith updates properly', () {
      final initialDate = DateTime(2026, 11, 18);
      var state = BookingSlotState(selectedDate: initialDate);

      const slot = AvailableSlotModel(timeSlot: '11:00 AM', isBooked: false);
      state = state.copyWith(selectedSlot: slot);

      expect(state.selectedSlot?.timeSlot, '11:00 AM');

      state = state.copyWith(clearSelectedSlot: true);
      expect(state.selectedSlot, isNull);
    });
  });
}
