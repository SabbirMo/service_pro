import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';

class TimeSlotGrid extends StatelessWidget {
  final List<AvailableSlotModel> slots;
  final AvailableSlotModel? selectedSlot;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<AvailableSlotModel> onSlotSelected;
  final VoidCallback onRetry;

  const TimeSlotGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.isLoading,
    required this.errorMessage,
    required this.onSlotSelected,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final availableCount = slots.where((s) => !s.isBooked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "AVAILABLE TIME SLOTS",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: const Color(0xFF334155),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            if (!isLoading && slots.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF86EFAC).withValues(alpha: 0.5),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  "$availableCount available",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF15803D),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF94A3B8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Grey = Booked",
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
          ],
        ),

        SizedBox(height: 14.h),

        // Body: Loading, Error, Empty, or Grid
        if (isLoading)
          _buildLoadingGrid()
        else if (errorMessage != null && errorMessage!.isNotEmpty)
          _buildErrorView(context)
        else if (slots.isEmpty)
          _buildEmptyView()
        else
          _buildSlotsGrid(context),
      ],
    );
  }

  Widget _buildSlotsGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: slots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = selectedSlot?.timeSlot == slot.timeSlot;
        final isBooked = slot.isBooked;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isBooked ? null : () => onSlotSelected(slot),
            borderRadius: BorderRadius.circular(14.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isBooked
                    ? const Color(0xFFF8FAFC)
                    : (isSelected
                        ? const Color(0xFFEEF2FF)
                        : AppColors.white),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isBooked
                      ? const Color(0xFFE2E8F0)
                      : (isSelected
                          ? const Color(0xFF1E56A0)
                          : const Color(0xFF1E56A0).withValues(alpha: 0.4)),
                  width: isSelected ? 1.8 : 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.16),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Slot Time Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            slot.startTime,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                              decoration: isBooked ? TextDecoration.lineThrough : null,
                              decorationColor: const Color(0xFF94A3B8),
                              color: isBooked
                                  ? const Color(0xFF94A3B8)
                                  : (isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary),
                            ),
                          ),
                        ),
                        if (slot.hasRange) ...[
                          SizedBox(height: 1.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "to ${slot.endTime}",
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: isBooked
                                    ? const Color(0xFF94A3B8)
                                    : (isSelected
                                        ? AppColors.primary.withValues(alpha: 0.85)
                                        : const Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(width: 6.w),

                  // Indicator on right: BOOKED badge or dot/checkmark
                  if (isBooked)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "BOOKED",
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    )
                  else if (isSelected)
                    Container(
                      width: 18.r,
                      height: 18.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.checkmark,
                        color: Colors.white,
                        size: 11.sp,
                      ),
                    )
                  else
                    Container(
                      width: 9.r,
                      height: 9.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.w,
                    height: 13.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 48.w,
                    height: 9.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2F6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
              Container(
                width: 9.r,
                height: 9.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.clock,
              size: 28.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "No Slots Available for this Date",
            style: TextStyle(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Please pick a different date from the date strip above.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle_fill,
                color: const Color(0xFFDC2626),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  errorMessage ?? "Failed to load slots",
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: const Color(0xFF991B1B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: Icon(CupertinoIcons.refresh, size: 14.sp),
              label: Text("Retry", style: TextStyle(fontSize: 12.sp)),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
