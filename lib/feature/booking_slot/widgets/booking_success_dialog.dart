import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';
import 'package:service_pro/feature/booking/widgets/booking_status_badge.dart';
import 'package:service_pro/feature/dashboard/provider/dashboard_notifier.dart';
import 'package:service_pro/router/app_page_name.dart';

class BookingSuccessDialog extends ConsumerWidget {
  final String? bookingId;
  final String serviceName;
  final String date;
  final String timeSlot;

  const BookingSuccessDialog({
    super.key,
    required this.bookingId,
    required this.serviceName,
    required this.date,
    required this.timeSlot,
  });

  static Future<void> show(
    BuildContext context, {
    required String? bookingId,
    required String serviceName,
    required String date,
    required String timeSlot,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => BookingSuccessDialog(
        bookingId: bookingId,
        serviceName: serviceName,
        date: date,
        timeSlot: timeSlot,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.checkmark_alt,
                color: const Color(0xFF16A34A),
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              "Booking Confirmed!",
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),

            Text(
              "Your appointment has been placed successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 16.h),

            // Booking Details Card inside Dialog
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  if (bookingId != null && bookingId!.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Booking ID",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "#${bookingId!.length > 8 ? bookingId!.substring(bookingId!.length - 8) : bookingId}",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 14.h, color: const Color(0xFFE2E8F0)),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Service",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          serviceName,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 14.h, color: const Color(0xFFE2E8F0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Date & Time",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          "$date • $timeSlot",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E56A0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 14.h, color: const Color(0xFFE2E8F0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const BookingStatusBadge(status: "Pending"),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(dashboardNotifierProvider.notifier).setIndex(1);
                  ref.read(bookingNotifierProvider.notifier).loadAll(showLoader: false);
                  context.go(AppPageName.dashboardScreen);
                },
                child: Text(
                  "View in My Bookings",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppPageName.dashboardScreen);
                },
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
