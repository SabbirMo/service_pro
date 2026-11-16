import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/core/widgets/custom_text_field.dart';
import 'package:service_pro/feature/auth/login/provider/login_notifier.dart';

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

  void _onSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle login action
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifer = ref.watch(loginNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF4F46E5,
                          ).withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.home_repair_service_rounded,
                        color: Colors.white,
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
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.4,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Subtitle
                  Text(
                    "Sign in to book trusted home & lifestyle services.",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: const Color(0xFF64748B),
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Password Field
                  CustomTextField(
                    label: "Password",
                    hintText: "••••••••",
                    controller: _passwordController,
                    obscureText: !notifer.password,
                    textInputAction: TextInputAction.done,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters required";
                      }
                      return null;
                    },
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
                        color: const Color(0xFF94A3B8),
                        size: 20.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 26.h),

                  // Sign In Button
                  CustomButton(text: "Sign In", onPressed: _onSignIn),

                  SizedBox(height: 28.h),

                  // Bottom Register Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Register Screen
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            color: const Color(0xFF4F46E5),
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
