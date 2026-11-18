import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/ai/model/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Message copied to clipboard"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 14.h, left: 48.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(4.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.white,
                  height: 1.35,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (message.timestamp != null) ...[
              SizedBox(height: 4.h),
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // AI Message Bubble
    final isError = message.isError;
    final isWelcome = message.id == "welcome_1";

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h, right: 28.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar
          Container(
            width: 32.w,
            height: 32.w,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              gradient: isError
                  ? const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                    )
                  : const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isError ? const Color(0xFFEF4444) : AppColors.primary)
                      .withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isError ? Icons.error_outline_rounded : Icons.auto_awesome_rounded,
              size: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.w),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: isError ? const Color(0xFFFEF2F2) : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                    border: Border.all(
                      color: isError
                          ? const Color(0xFFFCA5A5)
                          : AppColors.border.withValues(alpha: 0.8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormattedContent(context, message.text, isError),
                      if (!isWelcome) ...[
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => _copyToClipboard(context, message.text),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.copy_rounded,
                                    size: 13.sp,
                                    color: AppColors.textMuted,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Copy",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (message.timestamp != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Parses markdown **bold** and basic formatting cleanly into RichText
  Widget _buildFormattedContent(BuildContext context, String rawText, bool isError) {
    if (isError) {
      return Text(
        rawText,
        style: TextStyle(
          fontSize: 13.5.sp,
          color: const Color(0xFF991B1B),
          height: 1.45,
        ),
      );
    }

    final spans = <InlineSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(rawText)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: rawText.substring(lastMatchEnd, match.start),
            style: TextStyle(
              fontSize: 13.5.sp,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: TextStyle(
            fontSize: 13.5.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            height: 1.45,
          ),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < rawText.length) {
      spans.add(
        TextSpan(
          text: rawText.substring(lastMatchEnd),
          style: TextStyle(
            fontSize: 13.5.sp,
            color: AppColors.textPrimary,
            height: 1.45,
          ),
        ),
      );
    }

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }
}
