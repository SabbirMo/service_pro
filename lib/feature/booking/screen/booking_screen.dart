import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/feature/dashboard/provider/dashboard_notifier.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76.w,
                height: 76.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 36.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "No Bookings Yet",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Explore services and book your first service appointment in minutes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
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
          ),
        ),
      ),
    );
  }
}
