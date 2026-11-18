import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/core/network/error/api_error_handler.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/repository/booking_repository.dart';

class BookingState {
  final List<BookingModel> upcomingBookings;
  final List<BookingModel> previousBookings;
  final bool isLoadingUpcoming;
  final bool isLoadingPrevious;
  final String? cancellingBookingId;
  final int selectedTab; // 0 = Upcoming, 1 = Previous
  final String? errorMessage;

  const BookingState({
    this.upcomingBookings = const [],
    this.previousBookings = const [],
    this.isLoadingUpcoming = false,
    this.isLoadingPrevious = false,
    this.cancellingBookingId,
    this.selectedTab = 0,
    this.errorMessage,
  });

  bool get isLoadingCurrent =>
      selectedTab == 0 ? isLoadingUpcoming : isLoadingPrevious;

  List<BookingModel> get currentBookings =>
      selectedTab == 0 ? upcomingBookings : previousBookings;

  BookingState copyWith({
    List<BookingModel>? upcomingBookings,
    List<BookingModel>? previousBookings,
    bool? isLoadingUpcoming,
    bool? isLoadingPrevious,
    String? cancellingBookingId,
    bool clearCancellingId = false,
    int? selectedTab,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BookingState(
      upcomingBookings: upcomingBookings ?? this.upcomingBookings,
      previousBookings: previousBookings ?? this.previousBookings,
      isLoadingUpcoming: isLoadingUpcoming ?? this.isLoadingUpcoming,
      isLoadingPrevious: isLoadingPrevious ?? this.isLoadingPrevious,
      cancellingBookingId: clearCancellingId
          ? null
          : (cancellingBookingId ?? this.cancellingBookingId),
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class BookingNotifier extends Notifier<BookingState> {
  BookingRepository get _repository => ref.read(bookingRepositoryProvider);

  @override
  BookingState build() {
    // Initial fetch on mount
    Future.microtask(() => loadAll());
    return const BookingState(isLoadingUpcoming: true, isLoadingPrevious: true);
  }

  void switchTab(int index) {
    if (state.selectedTab == index) return;
    state = state.copyWith(selectedTab: index, clearErrorMessage: true);
    if (index == 0 && state.upcomingBookings.isEmpty) {
      loadUpcoming();
    } else if (index == 1 && state.previousBookings.isEmpty) {
      loadPrevious();
    }
  }

  Future<void> loadAll({bool showLoader = true}) async {
    await Future.wait([
      loadUpcoming(showLoader: showLoader),
      loadPrevious(showLoader: showLoader),
    ]);
  }

  Future<void> loadUpcoming({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(isLoadingUpcoming: true, clearErrorMessage: true);
    }

    try {
      final response = await _repository.getMyBookings(type: 'upcoming');
      state = state.copyWith(
        upcomingBookings: response.bookings,
        isLoadingUpcoming: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoadingUpcoming: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingUpcoming: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadPrevious({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(isLoadingPrevious: true, clearErrorMessage: true);
    }

    try {
      final response = await _repository.getMyBookings(type: 'previous');
      state = state.copyWith(
        previousBookings: response.bookings,
        isLoadingPrevious: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoadingPrevious: false,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingPrevious: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Cancel appointment: PATCH /api/bookings/:id/cancel
  Future<({bool success, String message})> cancelBooking(String bookingId) async {
    state = state.copyWith(
      cancellingBookingId: bookingId,
      clearErrorMessage: true,
    );

    try {
      final res = await _repository.cancelBooking(bookingId);
      final msg = res['message']?.toString() ?? 'Appointment cancelled successfully';

      // Refresh both lists so booking moves from upcoming to previous as "Cancelled"
      await loadAll();

      state = state.copyWith(clearCancellingId: true);
      return (success: true, message: msg);
    } on ApiException catch (e) {
      state = state.copyWith(
        clearCancellingId: true,
        errorMessage: e.message,
      );
      return (success: false, message: e.message);
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        clearCancellingId: true,
        errorMessage: msg,
      );
      return (success: false, message: msg);
    }
  }
}

final bookingNotifierProvider =
    NotifierProvider<BookingNotifier, BookingState>(BookingNotifier.new);
