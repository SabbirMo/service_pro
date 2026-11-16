import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/ai/screen/ai_screen.dart';
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
    final currentIndex = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: _views),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          ref.read(dashboardNotifierProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}
