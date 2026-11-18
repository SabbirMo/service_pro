import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';
import 'package:service_pro/feature/booking_slot/provider/booking_slot_notifier.dart';
import 'package:service_pro/feature/booking_slot/widgets/booking_bottom_bar.dart';
import 'package:service_pro/feature/booking_slot/widgets/date_picker_strip.dart';
import 'package:service_pro/feature/booking_slot/widgets/service_address_field.dart';
import 'package:service_pro/feature/booking_slot/widgets/special_instructions_field.dart';
import 'package:service_pro/feature/booking_slot/widgets/time_slot_grid.dart';
import 'package:service_pro/feature/home/model/service_model.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';
import 'package:service_pro/router/app_page_name.dart';

class BookingSlotScreen extends ConsumerStatefulWidget {
  final ServiceModel service;

  const BookingSlotScreen({
    super.key,
    required this.service,
  });

  @override
  ConsumerState<BookingSlotScreen> createState() => _BookingSlotScreenState();
}

class _BookingSlotScreenState extends ConsumerState<BookingSlotScreen> {
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _notesController = TextEditingController();

    // Prefill with user's real saved profile address if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = ref.read(profileNotifierProvider);
      final savedAddress = profileState.user.address;
      if (savedAddress.isNotEmpty && _addressController.text.isEmpty) {
        _addressController.text = savedAddress;
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmBooking() async {
    final state =
        ref.read(bookingSlotNotifierProvider(widget.service.id)).value;
    if (state == null) return;

    final selectedSlot = state.selectedSlot;
    if (selectedSlot == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                CupertinoIcons.info_circle_fill,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10.w),
              const Expanded(
                child: Text(
                  "Please select an available time slot first.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    final enteredAddress = _addressController.text.trim();
    if (enteredAddress.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_circle_fill,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10.w),
              const Expanded(
                child: Text(
                  "Please enter your service address before booking.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
      return;
    }

    final enteredNotes = _notesController.text.trim();
    final notifier =
        ref.read(bookingSlotNotifierProvider(widget.service.id).notifier);

    final result = await notifier.confirmBooking(
      address: enteredAddress,
      notes: enteredNotes,
    );

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10.w),
              const Expanded(
                child: Text(
                  "Booking confirmed successfully!",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      context.go(AppPageName.dashboardScreen);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_circle_fill,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  result.message ??
                      "Failed to confirm booking. Please choose another slot.",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncSlotState =
        ref.watch(bookingSlotNotifierProvider(widget.service.id));
    final slotNotifier =
        ref.read(bookingSlotNotifierProvider(widget.service.id).notifier);

    final slotData = asyncSlotState.value;
    final selectedDate = slotData?.selectedDate ?? DateTime.now();
    final slots = slotData?.slots ?? [];
    final selectedSlot = slotData?.selectedSlot;
    final isLoading = asyncSlotState.isLoading;
    final errorMessage = asyncSlotState.hasError
        ? asyncSlotState.error.toString().replaceFirst('Exception: ', '')
        : null;
    final isSubmitting = slotData?.isSubmitting ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFD),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Select Date & Time",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.service.name.isNotEmpty
                            ? widget.service.name
                            : "Service Appointment",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Choose Date
                  DatePickerStrip(
                    selectedDate: selectedDate,
                    onDateSelected: (newDate) {
                      slotNotifier.changeDate(newDate);
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Available Time Slots
                  TimeSlotGrid(
                    slots: slots,
                    selectedSlot: selectedSlot,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onSlotSelected: (slot) {
                      slotNotifier.selectSlot(slot);
                    },
                    onRetry: () {
                      slotNotifier.retry();
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Service Address
                  ServiceAddressField(
                    controller: _addressController,
                    onChanged: (val) {
                      slotNotifier.setAddress(val);
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Notes / Special Instructions
                  SpecialInstructionsField(
                    controller: _notesController,
                    onChanged: (val) {
                      slotNotifier.setNotes(val);
                    },
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar
          BookingBottomBar(
            price: widget.service.price,
            selectedSlot: selectedSlot,
            isSubmitting: isSubmitting,
            onConfirm: _handleConfirmBooking,
          ),
        ],
      ),
    );
  }
}
