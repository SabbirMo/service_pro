import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class DatePickerStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePickerStrip({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  static const List<String> _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Generate upcoming 30 days starting from today
    final dates = List.generate(30, (index) => today.add(Duration(days: index)));

    final monthName = _months[selectedDate.month - 1];
    final year = selectedDate.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "1. CHOOSE DATE ($monthName $year)",
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: const Color(0xFF334155),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            // Sleek Calendar Picker Pill
            InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: today,
                  lastDate: today.add(const Duration(days: 90)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.primary,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: AppColors.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Calendar",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Horizontal Date Selector
        SizedBox(
          height: 76.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: dates.length,
            separatorBuilder: (_, _) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;
              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              final weekday = _weekdays[date.weekday - 1];
              final dayNum = date.day.toString();

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58.w,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                          )
                        : null,
                    color: isSelected ? null : AppColors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isToday
                              ? AppColors.primary.withValues(alpha: 0.4)
                              : AppColors.border.withValues(alpha: 0.9)),
                      width: isSelected ? 1.6 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
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
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isToday ? "Today" : weekday,
                              style: TextStyle(
                                fontSize: isToday ? 11.sp : 12.sp,
                                fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : (isToday ? AppColors.primary : AppColors.textSecondary),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              dayNum,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
