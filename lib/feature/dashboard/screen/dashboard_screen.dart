import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/ai/screen/ai_screen.dart';
import 'package:service_pro/feature/booking/provider/booking_notifier.dart';
import 'package:service_pro/feature/booking/screen/booking_screen.dart';
import 'package:service_pro/feature/dashboard/provider/dashboard_notifier.dart';
import 'package:service_pro/feature/dashboard/widgets/custom_nav_bar.dart';
import 'package:service_pro/feature/home/screen/home_screen.dart';
import 'package:service_pro/feature/profile/screen/profile_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const List<Widget> _views = [
    HomeScreen(),
    BookingScreen(),
    AiScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(dashboardNotifierProvider, (previous, next) {
      if (next == 1) {
        // Automatically sync latest bookings whenever the Booking tab is opened
        ref.read(bookingNotifierProvider.notifier).loadAll(showLoader: false);
      }
    });

    final currentIndex = ref.watch(dashboardNotifierProvider);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: currentIndex, children: _views),
      bottomNavigationBar: isKeyboardOpen
          ? null
          : CustomNavBar(
              selectedIndex: currentIndex,
              onItemSelected: (index) {
                ref.read(dashboardNotifierProvider.notifier).setIndex(index);
              },
            ),
    );
  }
}
