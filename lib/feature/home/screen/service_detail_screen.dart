import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/home/model/category_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';
import 'package:service_pro/router/app_page_name.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  final String heroTag;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    this.heroTag = '',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeroTag = heroTag.isNotEmpty
        ? heroTag
        : 'service_img_${service.id}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // 1. Sliver App Bar with Image & Hero
              SliverAppBar(
                expandedHeight: 290.h,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.chevron_back,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: effectiveHeroTag,
                        child: service.image.isNotEmpty
                            ? Image.network(
                                service.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildFallbackHeader(),
                              )
                            : _buildFallbackHeader(),
                      ),
                      // Top gradient for back button contrast
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Category badge on top of image
                      Positioned(
                        bottom: 16.h,
                        left: 18.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CategoryModel.getIconForCategory(
                                  service.category,
                                ),
                                size: 14.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                service.category,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Service Information Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Rating & Reviews row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 16.sp,
                                  color: const Color(0xFFD97706),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  service.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "(${service.reviewCount} verified ratings)",
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (service.isFeatured) ...[
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "FEATURED",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 18.h),

                      // Price & Duration Cards
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.18,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Standard Price",
                                    style: TextStyle(
                                      fontSize: 11.5.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "\$${service.price.toInt()}",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF10B981,
                                ).withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: const Color(
                                    0xFF10B981,
                                  ).withValues(alpha: 0.18),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Service Duration",
                                    style: TextStyle(
                                      fontSize: 11.5.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "${service.durationMinutes} mins",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF047857),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 22.h),

                      // About Service Section
                      Text(
                        "About Service",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: AppColors.textSecondary,
                          height: 1.55,
                        ),
                      ),

                      SizedBox(height: 22.h),

                      // Why Choose Us
                      Text(
                        "What is Included",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.8),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildIncludedItem(
                              CupertinoIcons.checkmark_seal_fill,
                              "Certified & Verified Specialist",
                              "Experienced technicians with background verification.",
                            ),
                            Divider(height: 20.h, color: AppColors.border),
                            _buildIncludedItem(
                              CupertinoIcons.shield_fill,
                              "30-Day Service Guarantee",
                              "Free revisit if you encounter any issue after service.",
                            ),
                            Divider(height: 20.h, color: AppColors.border),
                            _buildIncludedItem(
                              CupertinoIcons.sparkles,
                              "Safe & Eco-Friendly Materials",
                              "Using genuine parts and non-toxic sanitizing solutions.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Sticky iOS-style Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "\$${service.price.toInt()}",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () {
                        context.push(
                          AppPageName.bookingSlotScreen,
                          extra: service,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Book Service Now",
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackHeader() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          CategoryModel.getIconForCategory(service.category),
          size: 64.sp,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildIncludedItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
