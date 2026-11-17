import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/theme/app_colors.dart';

class HomeSearchBar extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  const HomeSearchBar({
    super.key,
    required this.initialValue,
    required this.onSearch,
    required this.onClear,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      widget.onSearch(value.trim());
    });
    setState(() {});
  }

  void _onClearPressed() {
    _debounce?.cancel();
    _controller.clear();
    widget.onClear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: hasText
              ? AppColors.primary
              : AppColors.border.withValues(alpha: 0.9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onSubmitted: (value) {
          _debounce?.cancel();
          widget.onSearch(value.trim());
        },
        style: TextStyle(
          fontSize: 13.5.sp,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Search AC repair, cleaning, plumber...",
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22.sp,
            color: hasText ? AppColors.primary : AppColors.textMuted,
          ),
          suffixIcon: hasText
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: _onClearPressed,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}
