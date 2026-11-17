import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
          ),
        );
      },
    );
  }
}

class FeaturedServicesSkeleton extends StatelessWidget {
  const FeaturedServicesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(width: 14.w),
        itemBuilder: (context, index) => SkeletonBox(
          width: 230.w,
          height: 165.h,
          borderRadius: 18,
        ),
      ),
    );
  }
}

class ServiceListSkeleton extends StatelessWidget {
  final int count;

  const ServiceListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.7),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SkeletonBox(width: 78.w, height: 78.w, borderRadius: 14),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonBox(width: 70.w, height: 12.h, borderRadius: 4),
                        SkeletonBox(width: 36.w, height: 12.h, borderRadius: 4),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SkeletonBox(width: 150.w, height: 14.h, borderRadius: 4),
                    SizedBox(height: 6.h),
                    SkeletonBox(
                      width: double.infinity,
                      height: 11.h,
                      borderRadius: 4,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SkeletonBox(width: 45.w, height: 16.h, borderRadius: 4),
                        SizedBox(width: 10.w),
                        SkeletonBox(width: 60.w, height: 16.h, borderRadius: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
