import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/app_validator.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/core/widgets/custom_text_field.dart';
import 'package:service_pro/feature/profile/provider/password_visibility_notifier.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onChangePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(profileNotifierProvider.notifier)
          .changePassword(
            currentPassword: _currentPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password changed successfully!"),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        final error = ref.read(profileNotifierProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? "Failed to change password"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final visibility = ref.watch(passwordVisibilityProvider);
    final visibilityNotifier = ref.read(passwordVisibilityProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ensure your account stays secure by using a strong password with at least 6 characters.",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 24.h),

                // Current Password
                CustomTextField(
                  label: "Current Password",
                  hintText: "••••••••",
                  controller: _currentPasswordController,
                  obscureText: !visibility.obscureCurrent,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      AppValidator.requiredField(value, "Current password"),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibility.obscureCurrent
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20.sp,
                      color: AppColors.textMuted,
                    ),
                    onPressed: visibilityNotifier.toggleCurrent,
                  ),
                ),

                SizedBox(height: 18.h),

                // New Password
                CustomTextField(
                  label: "New Password",
                  hintText: "••••••••",
                  controller: _newPasswordController,
                  obscureText: !visibility.obscureNew,
                  textInputAction: TextInputAction.next,
                  validator: AppValidator.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibility.obscureNew
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20.sp,
                      color: AppColors.textMuted,
                    ),
                    onPressed: visibilityNotifier.toggleNew,
                  ),
                ),

                SizedBox(height: 18.h),

                // Confirm New Password
                CustomTextField(
                  label: "Confirm New Password",
                  hintText: "••••••••",
                  controller: _confirmPasswordController,
                  obscureText: !visibility.obscureConfirm,
                  textInputAction: TextInputAction.done,
                  validator: (value) => AppValidator.validateConfirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      visibility.obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20.sp,
                      color: AppColors.textMuted,
                    ),
                    onPressed: visibilityNotifier.toggleConfirm,
                  ),
                ),

                SizedBox(height: 32.h),

                // Update Password Button
                CustomButton(
                  text: "Update Password",
                  isLoading: profileState.isLoading,
                  onPressed: _onChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
