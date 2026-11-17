import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/app_validator.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/core/widgets/custom_text_field.dart';
import 'package:service_pro/feature/auth/login/provider/login_notifier.dart';
import 'package:service_pro/feature/auth/login/provider/login_provider.dart';
import 'package:service_pro/router/app_page_name.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(loginProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppPageName.dashboardScreen);
      } else {
        final error = ref.read(loginProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error != null ? error.toString() : "Login failed",
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifer = ref.watch(loginNotifierProvider);
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Brand Logo (Service Pro Logo)
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.home_repair_service_rounded,
                        color: AppColors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Title: Welcome back
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Subtitle
                  Text(
                    "Sign in to book trusted home & lifestyle services.",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // Email Address Field
                  CustomTextField(
                    label: "Email Address",
                    hintText: "sabbir.dev@example.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AppValidator.validateEmail,
                  ),

                  SizedBox(height: 20.h),

                  // Password Field
                  CustomTextField(
                    label: "Password",
                    hintText: "••••••••",
                    controller: _passwordController,
                    obscureText: !notifer.password,
                    textInputAction: TextInputAction.done,
                    validator: AppValidator.validatePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref
                            .read(loginNotifierProvider.notifier)
                            .passwordToggle();
                      },
                      icon: Icon(
                        notifer.password
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textMuted,
                        size: 20.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 26.h),

                  // Sign In Button
                  CustomButton(
                    text: "Sign In",
                    isLoading: loginState.isLoading,
                    onPressed: _onSignIn,
                  ),

                  SizedBox(height: 28.h),

                  // Bottom Register Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(AppPageName.registerScreen);
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
