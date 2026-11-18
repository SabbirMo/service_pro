import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_pro/feature/booking_slot/model/available_slot_model.dart';
import 'package:service_pro/feature/booking_slot/widgets/booking_bottom_bar.dart';
import 'package:service_pro/feature/booking_slot/widgets/date_picker_strip.dart';
import 'package:service_pro/feature/booking_slot/widgets/special_instructions_field.dart';
import 'package:service_pro/feature/booking_slot/widgets/time_slot_grid.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  testWidgets('DatePickerStrip displays header and dates properly', (tester) async {
    final selectedDate = DateTime(2026, 11, 18);

    await tester.pumpWidget(
      createTestWidget(
        DatePickerStrip(
          selectedDate: selectedDate,
          onDateSelected: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('CHOOSE DATE'), findsOneWidget);
    expect(find.textContaining('NOV 2026'), findsOneWidget);
  });

  testWidgets('TimeSlotGrid displays available and booked slots properly', (tester) async {
    final slots = [
      const AvailableSlotModel(timeSlot: '09:00 AM', isBooked: false),
      const AvailableSlotModel(timeSlot: '11:00 AM', isBooked: false),
      const AvailableSlotModel(timeSlot: '01:00 PM', isBooked: true),
      const AvailableSlotModel(timeSlot: '03:00 PM', isBooked: false),
    ];

    AvailableSlotModel? selectedSlot;

    await tester.pumpWidget(
      createTestWidget(
        TimeSlotGrid(
          slots: slots,
          selectedSlot: const AvailableSlotModel(timeSlot: '11:00 AM', isBooked: false),
          isLoading: false,
          errorMessage: null,
          onSlotSelected: (slot) => selectedSlot = slot,
          onRetry: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AVAILABLE TIME SLOTS'), findsOneWidget);
    expect(find.textContaining('available'), findsOneWidget);
    expect(find.text('09:00 AM'), findsOneWidget);
    expect(find.text('11:00 AM'), findsOneWidget);
    expect(find.text('01:00 PM'), findsOneWidget);
    expect(find.text('BOOKED'), findsOneWidget);

    // Tap on available slot
    await tester.tap(find.text('09:00 AM'));
    expect(selectedSlot?.timeSlot, '09:00 AM');
  });

  testWidgets('SpecialInstructionsField and BookingBottomBar render as expected', (tester) async {
    final controller = TextEditingController();
    bool confirmed = false;

    await tester.pumpWidget(
      createTestWidget(
        Column(
          children: [
            SpecialInstructionsField(controller: controller),
            BookingBottomBar(
              price: 45.0,
              selectedSlot: const AvailableSlotModel(timeSlot: '11:00 AM', isBooked: false),
              isSubmitting: false,
              onConfirm: () => confirmed = true,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SPECIAL INSTRUCTIONS / NOTES (OPTIONAL)'), findsOneWidget);
    expect(find.text('Confirm Booking • \$45'), findsOneWidget);

    await tester.tap(find.text('Confirm Booking • \$45'));
    expect(confirmed, true);
  });
}
