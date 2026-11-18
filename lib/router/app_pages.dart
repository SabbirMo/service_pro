import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/feature/auth/login/screen/login_screen.dart';
import 'package:service_pro/feature/auth/register/screen/register_screen.dart';
import 'package:service_pro/feature/booking/model/booking_model.dart';
import 'package:service_pro/feature/booking/screen/booking_details_screen.dart';
import 'package:service_pro/feature/booking_slot/screen/booking_slot_screen.dart';
import 'package:service_pro/feature/dashboard/screen/dashboard_screen.dart';
import 'package:service_pro/feature/home/model/service_model.dart';
import 'package:service_pro/feature/home/screen/service_detail_screen.dart';
import 'package:service_pro/feature/notification/screen/notification_screen.dart';
import 'package:service_pro/feature/profile/screen/change_password_screen.dart';
import 'package:service_pro/feature/profile/screen/edit_profile_screen.dart';
import 'package:service_pro/feature/splash/splash_screen.dart';
import 'package:service_pro/router/app_page_name.dart';

/// Safely extracts or deserializes [ServiceModel] from any parameter format.
ServiceModel? _extractServiceModel(dynamic extra) {
  if (extra == null) return null;

  if (extra is ServiceModel) {
    return extra;
  }

  if (extra is BookingServiceModel) {
    return ServiceModel(
      id: extra.id,
      name: extra.name,
      description: extra.description,
      category: extra.category,
      price: extra.price,
      durationMinutes: extra.durationMinutes,
      image: extra.image,
      isFeatured: false,
      rating: extra.rating,
      reviewCount: 0,
    );
  }

  if (extra is Map) {
    // 1. Check if it's wrapped in {'service': ..., 'heroTag': ...}
    final rawService = extra['service'];
    if (rawService is ServiceModel) {
      return rawService;
    }
    if (rawService is BookingServiceModel) {
      return ServiceModel(
        id: rawService.id,
        name: rawService.name,
        description: rawService.description,
        category: rawService.category,
        price: rawService.price,
        durationMinutes: rawService.durationMinutes,
        image: rawService.image,
        isFeatured: false,
        rating: rawService.rating,
        reviewCount: 0,
      );
    }
    if (rawService is Map) {
      return ServiceModel.fromJson(Map<String, dynamic>.from(rawService));
    }

    // 2. The map itself represents the service
    return ServiceModel.fromJson(Map<String, dynamic>.from(extra));
  }

  return null;
}

String _extractHeroTag(dynamic extra) {
  if (extra is Map && extra['heroTag'] != null) {
    return extra['heroTag'].toString();
  }
  return '';
}

// ignore: non_constant_identifier_names
final AppPages = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppPageName.splashScreen,
    routes: [
      GoRoute(
        path: AppPageName.splashScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const SplashScreen()),
      ),
      GoRoute(
        path: AppPageName.loginScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const LoginScreen()),
      ),
      GoRoute(
        path: AppPageName.registerScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const RegisterScreen()),
      ),
      GoRoute(
        path: AppPageName.dashboardScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const DashboardScreen()),
      ),
      GoRoute(
        path: AppPageName.editProfileScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const EditProfileScreen()),
      ),
      GoRoute(
        path: AppPageName.changePasswordScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(child: const ChangePasswordScreen()),
      ),
      GoRoute(
        path: AppPageName.serviceDetailScreen,
        pageBuilder: (context, state) {
          final service = _extractServiceModel(state.extra);
          final heroTag = _extractHeroTag(state.extra);

          if (service != null) {
            return CupertinoPage(
              key: state.pageKey,
              child: ServiceDetailScreen(
                service: service,
                heroTag: heroTag,
              ),
            );
          }

          return CupertinoPage(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.arrow_left),
                  onPressed: () => context.pop(),
                ),
                title: const Text("Service Details"),
              ),
              body: const Center(
                child: Text(
                  "Service details not found. Please select a service from Home.",
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppPageName.bookingSlotScreen,
        pageBuilder: (context, state) {
          final service = _extractServiceModel(state.extra);

          if (service != null) {
            return CupertinoPage(
              key: state.pageKey,
              child: BookingSlotScreen(service: service),
            );
          }

          return CupertinoPage(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(CupertinoIcons.arrow_left),
                  onPressed: () => context.pop(),
                ),
                title: const Text("Book Service"),
              ),
              body: const Center(
                child: Text(
                  "No service selected. Please choose a service to book.",
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppPageName.bookingDetailsScreen,
        pageBuilder: (context, state) {
          final extra = state.extra;
          String bookingId = '';
          BookingModel? initialBooking;

          if (extra is String) {
            bookingId = extra;
          } else if (extra is BookingModel) {
            bookingId = extra.id;
            initialBooking = extra;
          } else if (extra is Map) {
            final map = Map<String, dynamic>.from(extra);
            bookingId =
                (map['bookingId'] ?? map['id'] ?? map['_id'] ?? '').toString();
            if (map['booking'] is BookingModel) {
              initialBooking = map['booking'] as BookingModel;
            } else if (map['booking'] is Map) {
              try {
                initialBooking = BookingModel.fromJson(
                  Map<String, dynamic>.from(map['booking'] as Map),
                );
              } catch (_) {}
            } else if (map.containsKey('status') ||
                map.containsKey('service')) {
              try {
                initialBooking = BookingModel.fromJson(map);
                if (bookingId.isEmpty) {
                  bookingId = initialBooking.id;
                }
              } catch (_) {}
            }
          }

          return CupertinoPage(
            key: state.pageKey,
            child: BookingDetailsScreen(
              bookingId: bookingId,
              initialBooking: initialBooking,
            ),
          );
        },
      ),
      GoRoute(
        path: AppPageName.notificationScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const NotificationScreen()),
      ),
    ],
    errorBuilder: (context, state) =>
        Center(child: Text("Page not Found ${state.error}")),
  );
  return router;
});
