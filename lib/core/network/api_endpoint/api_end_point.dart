class ApiEndPoints {
  ApiEndPoints._();

  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String refreshToken = '/api/auth/refresh-token';

  // User endpoints
  static const String userProfile = '/api/users/me';
  static const String editProfile = '/api/users/edit-profile';
  static const String changePassword = '/api/users/change-password';

  // Service endpoints
  static const String services = '/api/services';

  // Booking endpoints
  static const String availableSlots = '/api/bookings/available-slots';
  static const String bookings = '/api/bookings';
  static const String myBookings = '/api/bookings/my-bookings';
  static String bookingDetail(String id) => '/api/bookings/$id';
  static String cancelBooking(String id) => '/api/bookings/$id/cancel';

  // AI Assistant endpoint
  static const String aiChat = '/api/ai/chat';
}
