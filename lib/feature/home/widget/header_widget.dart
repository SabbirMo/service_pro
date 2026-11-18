import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/getting.dart';
import 'package:service_pro/feature/notification/provider/notification_notifier.dart';
import 'package:service_pro/feature/profile/model/profile_state.dart';
import 'package:service_pro/router/app_page_name.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key, required this.profileState});

  final ProfileState profileState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount =
        ref.watch(notificationNotifierProvider.select((s) => s.unreadCount));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Getting.getGetting(),
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 2.h),
            Text(
              profileState.user.name,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: Icon(
                  unreadCount > 0
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  size: 22.sp,
                  color: unreadCount > 0
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
                onPressed: () {
                  context.push(AppPageName.notificationScreen);
                },
              ),
            ),
            // Unread Count Badge
            if (unreadCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: EdgeInsets.all(unreadCount > 9 ? 3.r : 4.r),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18.w,
                    minHeight: 18.w,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
