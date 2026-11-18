import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class ServiceAddressField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const ServiceAddressField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          "SERVICE ADDRESS",
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: const Color(0xFF334155),
          ),
        ),

        SizedBox(height: 12.h),

        // Address Box
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.015),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 2,
            minLines: 1,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: "Enter full address (e.g. House, Road, Area, City)...",
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Icon(
                  CupertinoIcons.location_solid,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 24.h,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 14.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
