import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/home/model/home_state.dart';
import 'package:service_pro/feature/home/provider/home_notifier.dart';
import 'package:service_pro/feature/home/widget/category_pills.dart';
import 'package:service_pro/feature/home/widget/featured_service_card.dart';
import 'package:service_pro/feature/home/widget/header_widget.dart';
import 'package:service_pro/feature/home/widget/home_empty_view.dart';
import 'package:service_pro/feature/home/widget/home_search_bar.dart';
import 'package:service_pro/feature/home/widget/home_skeletons.dart';
import 'package:service_pro/feature/home/widget/service_card.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150) {
      ref.read(homeNotifierProvider.notifier).loadMoreServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final homeNotifier = ref.read(homeNotifierProvider.notifier);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.wait([
              ref.read(profileNotifierProvider.notifier).fetchUserProfile(),
              homeNotifier.refresh(),
            ]);
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: User Greeting & Notifications
                HeaderWidget(profileState: profileState),

                SizedBox(height: 16.h),

                // 1. Search Bar (real-time filter with debounce)
                HomeSearchBar(
                  initialValue: homeState.searchQuery,
                  onSearch: (query) {
                    homeNotifier.searchServices(query);
                  },
                  onClear: () {
                    homeNotifier.clearSearch();
                  },
                ),

                SizedBox(height: 14.h),

                // 2. Dynamic Category Pills (No dummy data)
                if (homeState.categories.isNotEmpty)
                  CategoryPills(
                    categories: homeState.categories,
                    selectedCategory: homeState.selectedCategory,
                    onSelectCategory: (category) {
                      homeNotifier.selectCategory(category);
                    },
                  ),

                SizedBox(height: 22.h),

                // 3. FEATURED SERVICES Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FEATURED SERVICES",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "Top Rated",
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Featured Services List (Image background, frosted overlays)
                if (homeState.isFeaturedLoading)
                  const FeaturedServicesSkeleton()
                else if (homeState.featuredServices.isNotEmpty)
                  SizedBox(
                    height: 165.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: homeState.featuredServices.length,
                      itemBuilder: (context, index) {
                        final service = homeState.featuredServices[index];
                        return FeaturedServiceCard(
                          service: service,
                          index: index,
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: BoxDecoration(
                      color: AppColors.border.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: Text(
                        "No featured services available at the moment",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: 26.h),

                // 4. ALL SERVICES Section Header (Count removed as requested)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _buildSectionTitle(homeState),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (homeState.selectedCategory != 'All' ||
                        homeState.searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () => homeNotifier.resetFilters(),
                        child: Text(
                          "Reset Filters",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12.h),

                // 5. Services List or States (Loading / Error / Empty / List with Pagination)
                if (homeState.isLoading)
                  const ServiceListSkeleton(count: 4)
                else if (homeState.errorMessage != null)
                  HomeEmptyView(
                    icon: Icons.cloud_off_rounded,
                    title: "Could Not Load Services",
                    message: homeState.errorMessage!,
                    buttonText: "Try Again",
                    onAction: () => homeNotifier.refresh(),
                  )
                else if (homeState.services.isEmpty)
                  HomeEmptyView(
                    icon: Icons.search_off_rounded,
                    title: "No Services Found",
                    message: homeState.searchQuery.isNotEmpty
                        ? 'No services matching "${homeState.searchQuery}" in ${homeState.selectedCategory}.'
                        : 'No services currently listed under ${homeState.selectedCategory}.',
                    buttonText: "View All Services",
                    onAction: () => homeNotifier.resetFilters(),
                  )
                else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeState.services.length,
                    itemBuilder: (context, index) {
                      final service = homeState.services[index];
                      return ServiceCard(service: service);
                    },
                  ),

                  // Pagination Loading Indicator / Load More
                  if (homeState.isLoadingMore)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Loading more services...",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (homeState.hasNextPage)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primary.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 10.h,
                            ),
                          ),
                          onPressed: () => homeNotifier.loadMoreServices(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Load More Services",
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],

                // Bottom padding to avoid overlapping floating navbar
                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Title without any count number
  String _buildSectionTitle(HomeState state) {
    if (state.searchQuery.isNotEmpty) {
      return "SEARCH RESULTS";
    }
    if (state.selectedCategory != "All") {
      return "${state.selectedCategory.toUpperCase()} SERVICES";
    }
    return "ALL SERVICES";
  }
}
