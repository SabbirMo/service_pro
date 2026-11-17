import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/token_storage.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';
import 'package:service_pro/feature/profile/repository/profile_repository.dart';
import 'package:service_pro/router/app_page_name.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndRedirect();
  }

  Future<void> _checkTokenAndRedirect() async {
    final startTime = DateTime.now();
    bool isAuthorized = false;

    try {
      final token = await TokenStorage.getAccessToken();

      if (token != null && token.trim().isNotEmpty) {
        // First check local JWT validity
        final isLocallyValid = await TokenStorage.hasValidAccessToken();

        try {
          // Verify with backend via profile endpoint (which uses AuthInterceptor to auto-refresh if expired)
          final profile = await ref.read(profileRepositoryProvider).getUserProfile();
          if (profile.email.isNotEmpty) {
            isAuthorized = true;
            // Pre-populate profile state for instant home header rendering
            await ref.read(profileNotifierProvider.notifier).fetchUserProfile();
          }
        } catch (e) {
          final errorStr = e.toString().toLowerCase();
          final isAuthError = errorStr.contains('401') ||
              errorStr.contains('not authorized') ||
              errorStr.contains('token failed') ||
              errorStr.contains('expired');

          if (isAuthError) {
            // Token is rejected and refresh failed: clear storage
            isAuthorized = false;
            await TokenStorage.clearTokens();
          } else {
            // Network connection error / offline fallback:
            // If token is locally valid, allow entry to dashboard
            isAuthorized = isLocallyValid;
            if (!isLocallyValid) {
              await TokenStorage.clearTokens();
            }
          }
        }
      } else {
        isAuthorized = false;
        await TokenStorage.clearTokens();
      }
    } catch (_) {
      isAuthorized = false;
      await TokenStorage.clearTokens();
    }

    // Ensure smooth branding duration of at least 1.8 seconds
    final elapsed = DateTime.now().difference(startTime);
    const minSplashDuration = Duration(milliseconds: 1800);
    if (elapsed < minSplashDuration) {
      await Future.delayed(minSplashDuration - elapsed);
    }

    if (!mounted) return;

    // Navigate to dashboard if valid, otherwise login screen
    if (isAuthorized) {
      context.go(AppPageName.dashboardScreen);
    } else {
      context.go(AppPageName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Logo
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.home_repair_service_rounded,
                  size: 46.sp,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 22.h),

              // Title
              Text(
                "Service Pro",
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(height: 8.h),

              // Subtitle
              Text(
                "Service Booking & Management App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 36.h),

              // Subtle Loading Indicator
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
