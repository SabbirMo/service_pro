import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/app_validator.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/core/widgets/custom_text_field.dart';
import 'package:service_pro/feature/auth/register/provider/register_notifier.dart';
import 'package:service_pro/router/app_page_name.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle registration logic
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifer = ref.watch(registerNotifierProvider);

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
                  // App Brand Logo (Service Pro)
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

                  // Title: Create account
                  Text(
                    "Create account",
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
                    "Sign up to book and manage trusted services.",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // 1. Full Name Field
                  CustomTextField(
                    label: "Full Name",
                    hintText: "Sabbir Ahmed",
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: AppValidator.validateFullName,
                  ),

                  SizedBox(height: 20.h),

                  // 2. Email Address Field
                  CustomTextField(
                    label: "Email",
                    hintText: "sabbir.dev@example.com",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AppValidator.validateEmail,
                  ),

                  SizedBox(height: 20.h),

                  // 3. Password Field with Toggle
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
                            .read(registerNotifierProvider.notifier)
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

                  // Register / Sign Up Button
                  CustomButton(
                    text: "Sign Up",
                    isLoading: notifer.isLoading,
                    onPressed: _onRegister,
                  ),

                  SizedBox(height: 28.h),

                  // Bottom: Already have an account? Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppPageName.loginScreen);
                          }
                        },
                        child: Text(
                          "Sign In",
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
