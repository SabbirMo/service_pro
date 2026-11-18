import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class SpecialInstructionsField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SpecialInstructionsField({
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
          "SPECIAL INSTRUCTIONS / NOTES (OPTIONAL)",
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: const Color(0xFF334155),
          ),
        ),

        SizedBox(height: 12.h),

        // Textarea Box
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
          child: Stack(
            children: [
              TextFormField(
                controller: controller,
                onChanged: onChanged,
                maxLines: 4,
                minLines: 3,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.45,
                ),
                decoration: InputDecoration(
                  hintText: "Apartment number, landmark, or specific issue...",
                  hintStyle: TextStyle(
                    fontSize: 13.5.sp,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),

              // Subtle resize grip aesthetic in bottom right corner (from screenshot)
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: CustomPaint(
                  size: Size(10.w, 10.w),
                  painter: _ResizeGripPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResizeGripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width, size.height - 7),
      Offset(size.width - 7, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - 3),
      Offset(size.width - 3, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
