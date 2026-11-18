import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/api_endpoint/api_end_point.dart';
import 'package:service_pro/core/network/service/api_services.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';

class BookingRepository {
  final ApiServices _apiServices;

  BookingRepository(this._apiServices);

  /// Get My Bookings: GET /api/bookings/my-bookings?type=`upcoming` or `previous`
  Future<MyBookingsResponseModel> getMyBookings({required String type}) async {
    final response = await _apiServices.get<Map<String, dynamic>>(
      ApiEndPoints.myBookings,
      queryParameters: {'type': type},
      requireAuth: true,
    );

    return MyBookingsResponseModel.fromJson(response.data ?? {});
  }

  /// Get Single Booking Details: GET /api/bookings/:id
  Future<SingleBookingResponseModel> getBookingDetails(String id) async {
    final response = await _apiServices.get<Map<String, dynamic>>(
      ApiEndPoints.bookingDetail(id),
      requireAuth: true,
    );

    return SingleBookingResponseModel.fromJson(response.data ?? {});
  }

  /// Cancel Pending Appointment: PATCH /api/bookings/:id/cancel
  Future<Map<String, dynamic>> cancelBooking(String id) async {
    final response = await _apiServices.patch<Map<String, dynamic>>(
      ApiEndPoints.cancelBooking(id),
      requireAuth: true,
    );

    return response.data ?? {'success': true};
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.watch(apiServicesProvider));
});
