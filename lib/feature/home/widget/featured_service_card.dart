import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/home/model/category_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';
import 'package:service_pro/router/app_page_name.dart';

class FeaturedServiceCard extends StatelessWidget {
  final ServiceModel service;
  final int index;

  const FeaturedServiceCard({
    super.key,
    required this.service,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'service_feat_${service.id}';

    return GestureDetector(
      onTap: () {
        context.push(
          AppPageName.serviceDetailScreen,
          extra: {
            'service': service,
            'heroTag': heroTag,
          },
        );
      },
      child: Container(
        width: 235.w,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Real service image background with Hero animation
              Hero(
                tag: heroTag,
                child: service.image.isNotEmpty
                    ? Image.network(
                        service.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.textDark,
                            child: const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackBackground(),
                      )
                    : _buildFallbackBackground(),
              ),

              // 2. High-contrast gradient overlay for readable text
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.black.withValues(alpha: 0.20),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),

              // 3. Card Content
              Padding(
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Category Icon Box & Rating Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Frosted Icon Box
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              CategoryModel.getIconForCategory(service.category),
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Frosted Rating Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.sp,
                                color: const Color(0xFFF59E0B),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                service.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Category tag (uppercase)
                    Text(
                      service.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Service Title
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.25,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Divider line
                    Container(
                      height: 1.h,
                      color: Colors.white.withValues(alpha: 0.22),
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                    ),

                    // Bottom Row: Price & Duration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${service.price.toInt()}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 13.sp,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${service.durationMinutes} mins",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildFallbackBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          CategoryModel.getIconForCategory(service.category),
          size: 48.sp,
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
