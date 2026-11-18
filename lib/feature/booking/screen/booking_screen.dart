import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';
import 'package:service_pro/feature/booking/widgets/booking_card.dart';
import 'package:service_pro/feature/booking/widgets/cancel_confirmation_dialog.dart';
import 'package:service_pro/feature/dashboard/provider/dashboard_notifier.dart';
import 'package:service_pro/router/app_page_name.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingNotifierProvider);
    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    final selectedTab = bookingState.selectedTab;
    final isLoading = bookingState.isLoadingCurrent;
    final currentBookings = bookingState.currentBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(62.h),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 14.h),
            color: Colors.white,
            child: _buildSegmentedTabs(
              context,
              selectedTab: selectedTab,
              onTabChanged: (index) => bookingNotifier.switchTab(index),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          if (selectedTab == 0) {
            await bookingNotifier.loadUpcoming(showLoader: false);
          } else {
            await bookingNotifier.loadPrevious(showLoader: false);
          }
        },
        child: _buildBody(
          context,
          ref,
          selectedTab: selectedTab,
          isLoading: isLoading,
          bookings: currentBookings,
          cancellingId: bookingState.cancellingBookingId,
          errorMessage: bookingState.errorMessage,
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs(
    BuildContext context, {
    required int selectedTab,
    required ValueChanged<int> onTabChanged,
  }) {
    return Container(
      height: 46.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Stack(
        children: [
          // Smooth Animated Sliding Pill Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 260),
            curve: Curves.fastOutSlowIn,
            alignment:
                selectedTab == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Clickable Text Labels with smooth text color animation
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(11.r),
                    splashColor: AppColors.primary.withValues(alpha: 0.05),
                    highlightColor: Colors.transparent,
                    onTap: () => onTabChanged(0),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedTab == 0
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selectedTab == 0
                              ? AppColors.textPrimary
                              : const Color(0xFF64748B),
                          letterSpacing: 0.2,
                        ),
                        child: const Text("Upcoming"),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(11.r),
                    splashColor: AppColors.primary.withValues(alpha: 0.05),
                    highlightColor: Colors.transparent,
                    onTap: () => onTabChanged(1),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: selectedTab == 1
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selectedTab == 1
                              ? AppColors.textPrimary
                              : const Color(0xFF64748B),
                          letterSpacing: 0.2,
                        ),
                        child: const Text("Previous"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required int selectedTab,
    required bool isLoading,
    required List<BookingModel> bookings,
    required String? cancellingId,
    required String? errorMessage,
  }) {
    if (isLoading && bookings.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (errorMessage != null && bookings.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 48.sp,
                color: const Color(0xFF94A3B8),
              ),
              SizedBox(height: 12.h),
              Text(
                "Unable to load bookings",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: "Try Again",
                width: 130.w,
                height: 38.h,
                borderRadius: 10.r,
                onPressed: () {
                  ref.read(bookingNotifierProvider.notifier).loadAll();
                },
              ),
            ],
          ),
        ),
      );
    }

    if (bookings.isEmpty) {
      return _buildEmptyState(context, ref, selectedTab: selectedTab);
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final isThisCancelling = cancellingId == booking.id;

        return BookingCard(
          booking: booking,
          isCancelling: isThisCancelling,
          onViewDetails: () {
            context.push(
              AppPageName.bookingDetailsScreen,
              extra: booking,
            );
          },
          onCancel: () async {
            final confirm = await CancelConfirmationDialog.show(
              context,
              serviceName: booking.service.name,
            );
            if (confirm != true) return;

            final result = await ref
                .read(bookingNotifierProvider.notifier)
                .cancelBooking(booking.id);

            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        result.success
                            ? CupertinoIcons.checkmark_circle_fill
                            : CupertinoIcons.exclamationmark_circle_fill,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          result.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: result.success
                      ? AppColors.success
                      : const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref, {
    required int selectedTab,
  }) {
    final isUpcoming = selectedTab == 0;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.calendar_month_rounded
                    : Icons.history_rounded,
                size: 38.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              isUpcoming ? "No Upcoming Appointments" : "No Past Bookings",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isUpcoming
                  ? "Explore services and book your first service appointment in minutes."
                  : "Your completed, cancelled, and past service appointments will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            if (isUpcoming) ...[
              SizedBox(height: 22.h),
              CustomButton(
                text: "Explore Services",
                width: 170.w,
                height: 42.h,
                borderRadius: 12.r,
                fontSize: 13.5.sp,
                onPressed: () {
                  ref.read(dashboardNotifierProvider.notifier).setIndex(0);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
