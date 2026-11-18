import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const BookingStatusBadge({
    super.key,
    required this.status,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        break;
      case 'confirmed':
        bg = const Color(0xFFDBEAFE);
        text = const Color(0xFF1D4ED8);
        break;
      case 'completed':
        bg = const Color(0xFFD1FAE5);
        text = const Color(0xFF047857);
        break;
      case 'cancelled':
        bg = const Color(0xFFFEE2E2);
        text = const Color(0xFFDC2626);
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF475569);
    }

    final displayStatus = status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : 'Unknown';

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: text.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          fontSize: fontSize ?? 11.5.sp,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
