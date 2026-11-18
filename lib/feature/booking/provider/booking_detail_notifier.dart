import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';
import 'package:service_pro/feature/booking/repository/booking_repository.dart';

class BookingDetailState {
  final BookingModel? booking;
  final bool isLoading;
  final bool isCancelling;
  final String? errorMessage;

  const BookingDetailState({
    this.booking,
    this.isLoading = false,
    this.isCancelling = false,
    this.errorMessage,
  });

  BookingDetailState copyWith({
    BookingModel? booking,
    bool? isLoading,
    bool? isCancelling,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BookingDetailState(
      booking: booking ?? this.booking,
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class BookingDetailNotifier extends Notifier<BookingDetailState> {
  final String bookingId;

  BookingDetailNotifier(this.bookingId);

  BookingRepository get _repository => ref.read(bookingRepositoryProvider);

  @override
  BookingDetailState build() {
    Future.microtask(() => loadBooking());
    return const BookingDetailState(isLoading: true);
  }

  Future<void> loadBooking({BookingModel? fallback}) async {
    state = state.copyWith(
      isLoading: true,
      booking: fallback ?? state.booking,
      clearErrorMessage: true,
    );

    try {
      final res = await _repository.getBookingDetails(bookingId);
      state = state.copyWith(
        booking: res.booking,
        isLoading: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<({bool success, String message})> cancelBooking() async {
    state = state.copyWith(isCancelling: true, clearErrorMessage: true);

    try {
      final res = await _repository.cancelBooking(bookingId);
      final msg = res['message']?.toString() ?? 'Appointment cancelled successfully';

      // Reload detail
      final detail = await _repository.getBookingDetails(bookingId);

      // Also refresh the parent booking list
      ref.read(bookingNotifierProvider.notifier).loadAll();

      state = state.copyWith(
        booking: detail.booking,
        isCancelling: false,
      );
      return (success: true, message: msg);
    } on ApiException catch (e) {
      state = state.copyWith(isCancelling: false, errorMessage: e.message);
      return (success: false, message: e.message);
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isCancelling: false, errorMessage: msg);
      return (success: false, message: msg);
    }
  }
}

final bookingDetailNotifierProvider = NotifierProvider.autoDispose
    .family<BookingDetailNotifier, BookingDetailState, String>(
  (bookingId) => BookingDetailNotifier(bookingId),
);
