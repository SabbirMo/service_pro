import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/getting.dart';
import 'package:service_pro/feature/home/provider/home_notifier.dart';
import 'package:service_pro/feature/home/widget/header_widget.dart';
import 'package:service_pro/feature/profile/model/profile_state.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(profileNotifierProvider.notifier).fetchUserProfile();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar: Location & Notification
                HeaderWidget(profileState: profileState),

                SizedBox(height: 20.h),

                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.border.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 22.sp,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Search for any service (e.g. AC, Cleaning)",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                // Promo Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                "SPECIAL OFFER",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Get 30% Off on\nYour First Service!",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 48.sp,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 26.h),

                // Categories Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Category Grid populated from HomeState
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: homeState.categories.map((category) {
                    final isSelected =
                        homeState.selectedCategory == category.title;

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(homeNotifierProvider.notifier)
                            .selectCategory(category.title);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              category.icon,
                              size: 28.sp,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // Bottom spacing to prevent floating navbar overlap
                SizedBox(height: 90.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
