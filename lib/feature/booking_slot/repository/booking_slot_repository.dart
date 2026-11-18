import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';

class BookingSlotRepository {
  final ApiServices _apiServices;

  BookingSlotRepository(this._apiServices);

  /// Formats [DateTime] into `yyyy-MM-dd`
  static String formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// GET /api/bookings/available-slots?serviceId=...&date=YYYY-MM-DD
  Future<AvailableSlotsResponseModel> getAvailableSlots({
    required String serviceId,
    required DateTime date,
  }) async {
    final dateString = formatDate(date);

    final response = await _apiServices.get<Map<String, dynamic>>(
      ApiEndPoints.availableSlots,
      queryParameters: {
        'serviceId': serviceId,
        'date': dateString,
      },
      requireAuth: true,
    );

    final data = response.data;
    if (data != null) {
      return AvailableSlotsResponseModel.fromJson(data);
    }

    throw Exception('Invalid response format received from available-slots API');
  }

  /// Optional: POST /api/bookings to confirm/create the booking
  Future<Map<String, dynamic>> createBooking({
    required String serviceId,
    required DateTime date,
    required String timeSlot,
    String? specialInstructions,
  }) async {
    final dateString = formatDate(date);

    final response = await _apiServices.post<Map<String, dynamic>>(
      ApiEndPoints.bookings,
      data: {
        'serviceId': serviceId,
        'date': dateString,
        'timeSlot': timeSlot,
        if (specialInstructions != null && specialInstructions.trim().isNotEmpty)
          'specialInstructions': specialInstructions.trim(),
      },
      requireAuth: true,
    );

    return response.data ?? {'success': true};
  }
}

final bookingSlotRepositoryProvider = Provider<BookingSlotRepository>((ref) {
  return BookingSlotRepository(ref.watch(apiServicesProvider));
});
