import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSend;
  final double bottomPadding;

  const ChatInputBar({
    super.key,
    required this.controller,
    this.focusNode,
    required this.onSend,
    required this.bottomPadding,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_textListener);
  }

  void _textListener() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      setState(() {
        _hasText = has;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: EdgeInsets.only(bottom: widget.bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 100.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: _hasText
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1.2,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (_hasText) widget.onSend();
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                decoration: InputDecoration(
                  hintText: "Ask anything about services, prices...",
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textMuted,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _hasText ? widget.onSend : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: _hasText
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _hasText ? null : AppColors.border.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                boxShadow: _hasText
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: _hasText ? Colors.white : AppColors.textMuted,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
