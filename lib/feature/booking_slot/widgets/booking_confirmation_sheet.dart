import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';
import 'package:service_pro/router/app_page_name.dart';

class BookingConfirmationSheet extends StatelessWidget {
  final ServiceModel service;
  final DateTime date;
  final AvailableSlotModel slot;
  final String specialInstructions;
  final Future<bool> Function() onConfirm;

  const BookingConfirmationSheet({
    super.key,
    required this.service,
    required this.date,
    required this.slot,
    required this.specialInstructions,
    required this.onConfirm,
  });

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    final formattedDate = "$weekday, ${date.day} $month ${date.year}";

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44.w,
                height: 4.5.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            SizedBox(height: 18.h),

            // Sheet Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Confirm Appointment",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 16.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Service Summary Card
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: service.image.isNotEmpty
                        ? Image.network(
                            service.image,
                            width: 54.w,
                            height: 54.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _buildFallbackIcon(),
                          )
                        : _buildFallbackIcon(),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          service.category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "\$${service.price.toInt()}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Booking details list
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    CupertinoIcons.calendar,
                    "Date",
                    formattedDate,
                  ),
                  Divider(height: 18.h, color: const Color(0xFFF1F5F9)),
                  _buildDetailRow(
                    CupertinoIcons.clock,
                    "Time Slot",
                    slot.timeSlot,
                  ),
                  if (specialInstructions.trim().isNotEmpty) ...[
                    Divider(height: 18.h, color: const Color(0xFFF1F5F9)),
                    _buildDetailRow(
                      CupertinoIcons.text_quote,
                      "Instructions",
                      specialInstructions.trim(),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final success = await onConfirm();
                    if (context.mounted && success) {
                      _showSuccessDialog(context);
                    }
                  },
                  child: Text(
                    "Confirm Appointment • \$${service.price.toInt()}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 54.w,
      height: 54.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        CupertinoIcons.wrench_fill,
        color: AppColors.primary,
        size: 24.sp,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
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
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68.w,
                height: 68.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: const Color(0xFF16A34A),
                  size: 38.sp,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "Booking Confirmed!",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Your appointment for ${service.name} has been successfully scheduled for ${slot.timeSlot}.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Navigate to Dashboard / Home
                    context.go(AppPageName.dashboardScreen);
                  },
                  child: Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
