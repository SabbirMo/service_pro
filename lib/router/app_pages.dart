import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/feature/auth/login/screen/login_screen.dart';
import 'package:service_pro/feature/auth/register/screen/register_screen.dart';
import 'package:service_pro/feature/dashboard/screen/dashboard_screen.dart';
import 'package:service_pro/feature/profile/screen/change_password_screen.dart';
import 'package:service_pro/feature/profile/screen/edit_profile_screen.dart';
import 'package:service_pro/feature/splash/splash_screen.dart';
import 'package:service_pro/router/app_page_name.dart';

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
    ],
    errorBuilder: (context, state) =>
        Center(child: Text("Page not Found ${state.error}")),
  );
  return router;
});
