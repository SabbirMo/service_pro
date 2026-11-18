import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/notification/model/notification_model.dart';
import 'package:service_pro/feature/notification/provider/notification_notifier.dart';
import 'package:service_pro/router/app_page_name.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationNotifierProvider);
    final notificationNotifier = ref.read(
      notificationNotifierProvider.notifier,
    );

    final notifications = notificationState.notifications;
    final unreadCount = notificationState.unreadCount;
    final isLoading = notificationState.isLoading;
    final isMarkingAll = notificationState.isMarkingAllRead;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: AppColors.textPrimary,
            size: 22.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              "Notifications",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: TextButton(
                onPressed: isMarkingAll
                    ? null
                    : () async {
                        final success = await notificationNotifier
                            .markAllAsRead();
                        if (context.mounted && success) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "All notifications marked as read",
                              ),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                child: isMarkingAll
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        "Mark all read",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            notificationNotifier.fetchNotifications(showLoader: false),
        child: isLoading && notifications.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : notifications.isEmpty
            ? _buildEmptyView(context)
            : _buildNotificationList(context, ref, notifications),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.bell_slash,
                size: 36.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "No Notifications Yet",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "We'll notify you when new booking requests, confirmations, or service updates arrive.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    BuildContext context,
    WidgetRef ref,
    List<NotificationModel> notifications,
  ) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return _buildNotificationCard(context, ref, item);
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    WidgetRef ref,
    NotificationModel item,
  ) {
    final isUnread = !item.isRead;
    final isBooking = item.type.toUpperCase() == 'BOOKING';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () async {
          // Mark as read
          if (isUnread) {
            ref.read(notificationNotifierProvider.notifier).markAsRead(item.id);
          }

          // If linked to a booking, open Booking Details
          if (item.bookingId != null && item.bookingId!.isNotEmpty) {
            context.push(
              AppPageName.bookingDetailsScreen,
              extra: item.bookingId,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isUnread ? const Color(0xFFF6F8FF) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isUnread
                  ? const Color(0xFFC7D2FE)
                  : const Color(0xFFE2E8F0),
              width: isUnread ? 1.4 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isUnread ? 0.04 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: isUnread
                      ? const Color(0xFFEEF2FF)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBooking
                      ? CupertinoIcons.calendar_badge_plus
                      : CupertinoIcons.bell_fill,
                  size: 20.sp,
                  color: isUnread ? AppColors.primary : const Color(0xFF64748B),
                ),
              ),

              SizedBox(width: 12.w),

              // Title, Message, and Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isUnread
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: 6.w),
                          Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4F46E5),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Notification Body Message
                    Text(
                      item.message,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Timestamp & Action hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.timeAgo,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        if (item.bookingId != null &&
                            item.bookingId!.isNotEmpty)
                          Row(
                            children: [
                              Text(
                                "View Booking",
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                CupertinoIcons.chevron_right,
                                size: 11.sp,
                                color: AppColors.primary,
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
}
