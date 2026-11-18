import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/provider/booking_detail_notifier.dart';
import 'package:service_pro/feature/booking/widgets/booking_status_badge.dart';
import 'package:service_pro/feature/booking/widgets/cancel_confirmation_dialog.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  final String bookingId;
  final BookingModel? initialBooking;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
    this.initialBooking,
  });

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bookingDetailNotifierProvider(widget.bookingId).notifier)
          .loadBooking(fallback: widget.initialBooking);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState =
        ref.watch(bookingDetailNotifierProvider(widget.bookingId));

    final booking = detailState.booking ?? widget.initialBooking;
    final isLoading = detailState.isLoading && booking == null;
    final isCancelling = detailState.isCancelling;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: AppColors.textPrimary,
            size: 22.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Booking Details",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : booking == null
              ? _buildErrorView(detailState.errorMessage)
              : _buildBookingContent(booking),
      bottomNavigationBar: (booking != null && booking.canCancel)
          ? _buildCancelBottomBar(context, booking, isCancelling)
          : null,
    );
  }

  Widget _buildErrorView(String? errorMessage) {
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
              "Unable to load booking details",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              errorMessage ?? "Please check your network and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () {
                ref
                    .read(
                      bookingDetailNotifierProvider(widget.bookingId).notifier,
                    )
                    .loadBooking();
              },
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingContent(BookingModel booking) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Booking ID & Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "ID: #${booking.id.isNotEmpty && booking.id.length > 8 ? booking.id.substring(booking.id.length - 8) : booking.id}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF475569),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              BookingStatusBadge(
                status: booking.status,
                fontSize: 12.5.sp,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Service Info Card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: booking.service.image.isNotEmpty
                          ? Image.network(
                              booking.service.image,
                              width: 72.w,
                              height: 72.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildFallbackImage(),
                            )
                          : _buildFallbackImage(),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.service.name.isNotEmpty
                                ? booking.service.name
                                : "Service Appointment",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            booking.service.category.isNotEmpty
                                ? booking.service.category
                                : "General Service",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              if (booking.service.rating > 0) ...[
                                Icon(
                                  Icons.star_rounded,
                                  size: 16.sp,
                                  color: const Color(0xFFF59E0B),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  booking.service.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF334155),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                              if (booking.service.durationMinutes > 0) ...[
                                Icon(
                                  CupertinoIcons.stopwatch,
                                  size: 14.sp,
                                  color: const Color(0xFF64748B),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  "${booking.service.durationMinutes} mins",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (booking.service.description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    booking.service.description,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: const Color(0xFF64748B),
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Appointment Schedule Section
          _buildSectionCard(
            title: "APPOINTMENT SCHEDULE",
            icon: CupertinoIcons.calendar,
            children: [
              _buildDetailItem(
                icon: CupertinoIcons.calendar_today,
                label: "Date",
                value: booking.date,
              ),
              Divider(height: 18.h, color: const Color(0xFFF1F5F9)),
              _buildDetailItem(
                icon: CupertinoIcons.clock,
                label: "Time Slot",
                value: booking.timeSlot,
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Service Address Section
          _buildSectionCard(
            title: "SERVICE ADDRESS",
            icon: CupertinoIcons.location_solid,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    size: 18.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      booking.address.isNotEmpty
                          ? booking.address
                          : "No address provided",
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Special Instructions / Notes (if present)
          if (booking.notes.trim().isNotEmpty) ...[
            _buildSectionCard(
              title: "SPECIAL INSTRUCTIONS / NOTES",
              icon: CupertinoIcons.text_quote,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.text_quote,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        booking.notes.trim(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 14.h),
          ],

          // Customer Profile Info (if present)
          if (booking.user != null && booking.user!.name.isNotEmpty) ...[
            _buildSectionCard(
              title: "CUSTOMER DETAILS",
              icon: CupertinoIcons.person_fill,
              children: [
                _buildDetailItem(
                  icon: CupertinoIcons.person,
                  label: "Name",
                  value: booking.user!.name,
                ),
                if (booking.user!.email.isNotEmpty) ...[
                  Divider(height: 18.h, color: const Color(0xFFF1F5F9)),
                  _buildDetailItem(
                    icon: CupertinoIcons.mail,
                    label: "Email",
                    value: booking.user!.email,
                  ),
                ],
              ],
            ),
            SizedBox(height: 14.h),
          ],

          // Payment / Price Summary
          _buildSectionCard(
            title: "PAYMENT SUMMARY",
            icon: CupertinoIcons.money_dollar_circle,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Service Charge",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Text(
                    "\$${booking.totalPrice.toInt()}",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              Divider(height: 18.h, color: const Color(0xFFF1F5F9)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "\$${booking.totalPrice.toInt()}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16.sp, color: const Color(0xFF94A3B8)),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelBottomBar(
    BuildContext context,
    BookingModel booking,
    bool isCancelling,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            onPressed: isCancelling
                ? null
                : () async {
                    final confirm = await CancelConfirmationDialog.show(
                      context,
                      serviceName: booking.service.name,
                    );
                    if (confirm != true) return;

                    final result = await ref
                        .read(
                          bookingDetailNotifierProvider(
                            widget.bookingId,
                          ).notifier,
                        )
                        .cancelBooking();

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
            child: isCancelling
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Color(0xFFDC2626),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 18.sp,
                        color: const Color(0xFFDC2626),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Cancel Appointment",
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 72.w,
      height: 72.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        CupertinoIcons.wrench_fill,
        color: AppColors.primary,
        size: 32.sp,
      ),
    );
  }
}
