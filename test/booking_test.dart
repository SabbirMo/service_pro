import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';

void main() {
  group('BookingModel & Submodels Tests', () {
    test('BookingModel parses full response JSON correctly', () {
      final json = {
        "_id": "673b1a45c4b8e90012349999",
        "service": {
          "_id": "673a9f12c4b8e90012345678",
          "name": "AC Servicing & Gas Refill",
          "category": "AC & Appliances",
          "price": 45,
          "durationMinutes": 90,
          "image": "https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800",
          "rating": 4.9,
          "description": "Full deep clean and gas check"
        },
        "user": {
          "name": "Sabbir Ahmed",
          "email": "sabbir@test.com",
          "address": "Dhanmondi, Dhaka"
        },
        "date": "2026-11-18",
        "timeSlot": "11:00 AM",
        "address": "House 12, Road 5, Dhanmondi, Dhaka",
        "notes": "Apartment 4B, near city college",
        "totalPrice": 45,
        "status": "Pending"
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.id, "673b1a45c4b8e90012349999");
      expect(booking.service.name, "AC Servicing & Gas Refill");
      expect(booking.service.price, 45.0);
      expect(booking.service.durationMinutes, 90);
      expect(booking.service.rating, 4.9);
      expect(booking.user?.name, "Sabbir Ahmed");
      expect(booking.user?.email, "sabbir@test.com");
      expect(booking.date, "2026-11-18");
      expect(booking.timeSlot, "11:00 AM");
      expect(booking.address, "House 12, Road 5, Dhanmondi, Dhaka");
      expect(booking.notes, "Apartment 4B, near city college");
      expect(booking.totalPrice, 45.0);
      expect(booking.status, "Pending");
      expect(booking.isPending, true);
      expect(booking.canCancel, true);
    });

    test('BookingModel status colors conform to specification', () {
      const pending = BookingModel(
        id: '1',
        service: BookingServiceModel(name: 'AC'),
        date: '2026-11-18',
        timeSlot: '11:00 AM',
        address: 'Dhaka',
        totalPrice: 45,
        status: 'Pending',
      );
      expect(pending.statusBgColor, const Color(0xFFFEF3C7));
      expect(pending.statusTextColor, const Color(0xFFD97706));
      expect(pending.canCancel, true);

      const confirmed = BookingModel(
        id: '2',
        service: BookingServiceModel(name: 'Plumbing'),
        date: '2026-11-19',
        timeSlot: '01:00 PM',
        address: 'Dhaka',
        totalPrice: 60,
        status: 'Confirmed',
      );
      expect(confirmed.statusBgColor, const Color(0xFFDBEAFE));
      expect(confirmed.statusTextColor, const Color(0xFF1D4ED8));
      expect(confirmed.canCancel, false);

      const completed = BookingModel(
        id: '3',
        service: BookingServiceModel(name: 'Cleaning'),
        date: '2026-11-10',
        timeSlot: '09:00 AM',
        address: 'Dhaka',
        totalPrice: 30,
        status: 'Completed',
      );
      expect(completed.statusBgColor, const Color(0xFFD1FAE5));
      expect(completed.statusTextColor, const Color(0xFF047857));
      expect(completed.canCancel, false);

      const cancelled = BookingModel(
        id: '4',
        service: BookingServiceModel(name: 'Electrician'),
        date: '2026-11-05',
        timeSlot: '04:00 PM',
        address: 'Dhaka',
        totalPrice: 40,
        status: 'Cancelled',
      );
      expect(cancelled.statusBgColor, const Color(0xFFFEE2E2));
      expect(cancelled.statusTextColor, const Color(0xFFDC2626));
      expect(cancelled.canCancel, false);
    });

    test('MyBookingsResponseModel parses list of bookings', () {
      final json = {
        "success": true,
        "count": 2,
        "bookings": [
          {
            "_id": "1",
            "service": {"name": "Service A", "price": 50},
            "date": "2026-11-18",
            "timeSlot": "10:00 AM",
            "address": "Dhaka",
            "totalPrice": 50,
            "status": "Pending"
          },
          {
            "_id": "2",
            "service": {"name": "Service B", "price": 80},
            "date": "2026-11-19",
            "timeSlot": "02:00 PM",
            "address": "Dhaka",
            "totalPrice": 80,
            "status": "Confirmed"
          }
        ]
      };

      final response = MyBookingsResponseModel.fromJson(json);
      expect(response.success, true);
      expect(response.count, 2);
      expect(response.bookings.length, 2);
      expect(response.bookings[0].service.name, "Service A");
      expect(response.bookings[1].service.name, "Service B");
    });

    test('BookingState copyWith and tabs helper', () {
      final state = const BookingState(
        upcomingBookings: [
          BookingModel(
            id: '1',
            service: BookingServiceModel(name: 'AC'),
            date: '2026-11-18',
            timeSlot: '11:00 AM',
            address: 'Dhaka',
            totalPrice: 45,
            status: 'Pending',
          ),
        ],
        selectedTab: 0,
      );

      expect(state.currentBookings.length, 1);
      expect(state.isLoadingCurrent, false);

      final updated = state.copyWith(selectedTab: 1);
      expect(updated.currentBookings.isEmpty, true);
    });
  });
}
