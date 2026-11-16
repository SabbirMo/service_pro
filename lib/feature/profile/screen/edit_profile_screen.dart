import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_pro/core/theme/app_colors.dart';
import 'package:service_pro/core/utils/app_validator.dart';
import 'package:service_pro/core/widgets/custom_button.dart';
import 'package:service_pro/core/widgets/custom_text_field.dart';
import 'package:service_pro/feature/profile/model/user_profile_model.dart';
import 'package:service_pro/feature/profile/provider/profile_notifier.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileNotifierProvider).user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _addressController = TextEditingController(text: user.address);
    _imagePath = user.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to pick image: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(profileNotifierProvider.notifier).updatePersonalInfo(
            name: _nameController.text.trim(),
            address: _addressController.text.trim(),
            imagePath: _imagePath,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: AppColors.primary,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileNotifierProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Personal Information",
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
                // Top Centered Image Picker Avatar
                Center(
                  child: _buildAvatar(user),
                ),

                SizedBox(height: 24.h),

                // Full Name (Editable)
                CustomTextField(
                  label: "Full Name",
                  controller: _nameController,
                  validator: AppValidator.validateFullName,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 18.h),

                // Email Address (Read-Only)
                CustomTextField(
                  label: "Email Address",
                  controller: _emailController,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                ),

                SizedBox(height: 18.h),

                // Service Address (Editable)
                CustomTextField(
                  label: "Service Address",
                  controller: _addressController,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      AppValidator.requiredField(value, "Address"),
                ),

                SizedBox(height: 32.h),

                // Save Changes Button
                CustomButton(
                  text: "Save Changes",
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserProfileModel user) {
    final hasImage = _imagePath != null && _imagePath!.isNotEmpty;

    ImageProvider? imageProvider;
    if (hasImage) {
      if (kIsWeb) {
        imageProvider = NetworkImage(_imagePath!);
      } else {
        imageProvider = FileImage(File(_imagePath!));
      }
    }

    final initialLetter = user.name.trim().isNotEmpty
        ? user.name.trim()[0].toUpperCase()
        : "U";

    return GestureDetector(
      onTap: _pickImageFromGallery,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 2.5,
              ),
              image: imageProvider != null
                  ? DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageProvider == null
                ? Center(
                    child: Text(
                      initialLetter,
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 16.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
