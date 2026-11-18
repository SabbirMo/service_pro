import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';

class BookingBottomBar extends StatelessWidget {
  final double price;
  final AvailableSlotModel? selectedSlot;
  final bool isSubmitting;
  final VoidCallback onConfirm;

  const BookingBottomBar({
    super.key,
    required this.price,
    required this.selectedSlot,
    required this.isSubmitting,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final priceLabel = price > 0 ? " • \$${price.toInt()}" : "";
    final hasSelectedSlot = selectedSlot != null;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: hasSelectedSlot
                  ? const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: hasSelectedSlot ? null : const Color(0xFF818CF8),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: hasSelectedSlot
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.38),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () {
                      if (!hasSelectedSlot) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Please select an available time slot before continuing.",
                            ),
                            backgroundColor: const Color(0xFF1E293B),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                        return;
                      }
                      onConfirm();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: isSubmitting
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              hasSelectedSlot
                                  ? "Confirm Booking$priceLabel"
                                  : "Select a Time Slot$priceLabel",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        if (hasSelectedSlot) ...[
                          SizedBox(width: 8.w),
                          Icon(
                            CupertinoIcons.arrow_right,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
