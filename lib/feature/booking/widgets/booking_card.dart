import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/widgets/booking_status_badge.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isCancelling;
  final VoidCallback onViewDetails;
  final VoidCallback onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.isCancelling = false,
    required this.onViewDetails,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onViewDetails,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Service Image, Title/Category, and Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: booking.service.image.isNotEmpty
                          ? Image.network(
                              booking.service.image,
                              width: 64.w,
                              height: 64.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildFallbackImage(),
                            )
                          : _buildFallbackImage(),
                    ),
                    SizedBox(width: 12.w),

                    // Service Name & Category & Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  booking.service.name.isNotEmpty
                                      ? booking.service.name
                                      : "Service Appointment",
                                  style: TextStyle(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              BookingStatusBadge(status: booking.status),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            booking.service.category.isNotEmpty
                                ? booking.service.category
                                : "General Service",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "\$${booking.totalPrice.toInt()}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(height: 20.h, color: const Color(0xFFF1F5F9)),

                // Schedule Details Row: Date & TimeSlot
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 15.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        booking.date,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        CupertinoIcons.clock,
                        size: 15.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          booking.timeSlot,
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // Action Buttons Row: View Details & (Cancel if Pending)
                Row(
                  children: [
                    // View Details Button
                    Expanded(
                      child: SizedBox(
                        height: 38.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEF2FF),
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              side: const BorderSide(
                                color: Color(0xFFC7D2FE),
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: onViewDetails,
                          child: Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Cancel Button: Visible ONLY when status == "Pending"
                    if (booking.canCancel) ...[
                      SizedBox(width: 10.w),
                      Expanded(
                        child: SizedBox(
                          height: 38.h,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(
                                color: Color(0xFFFCA5A5),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: isCancelling ? null : onCancel,
                            child: isCancelling
                                ? SizedBox(
                                    width: 16.r,
                                    height: 16.r,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFDC2626),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.xmark_circle,
                                        size: 14.sp,
                                        color: const Color(0xFFDC2626),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 12.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ],
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
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        CupertinoIcons.wrench_fill,
        color: AppColors.primary,
        size: 26.sp,
      ),
    );
  }
}
