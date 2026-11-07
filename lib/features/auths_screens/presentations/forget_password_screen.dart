import 'package:fitoraa/core/routes_config/app_routes.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_buttons.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text.dart';
import '../../../utils/app_text_field.dart';
import 'controller/auth_controller.dart';

class ForgetPasswordScreen extends GetView<AuthController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              /// Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.lightBorder,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              /// Mail Icon
              Container(
                height: 16.h,
                width: 16.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightSurface,
                  border: Border.all(
                    color: AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(AppAssets.emailIcon,height: 8.h,)
                ),
              ),

              SizedBox(height: 5.h),

              /// Title
              AppText(
                "Forgot Password?",
                type: AppTextType.heading1,
                textAlign: TextAlign.center,
                color: AppColors.lightTextPrimary,
              ),

              SizedBox(height: 1.5.h),

              /// Description
              AppText(
                "Enter your email and we'll send\nyou a secure reset link.",
                type: AppTextType.caption,
                textAlign: TextAlign.center,
                color: AppColors.lightTextSecondary,
              ),

              SizedBox(height: 5.h),

              /// Email Field
              AppFormField(
                title: "Email address",
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "email are required";
                  }
                  final email = value.trim();
                  final regEmail = RegExp( r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if(!regEmail.hasMatch(email)){
                    return "Email are bed formated";
                  }
                  return null;
                },

                textEditingController: controller.emailController,
                textInputType: TextInputType.emailAddress,
                preficIconwidth: 5.w,
                showBorder: true,
                isFilled: true,
                filledColor: AppColors.lightSurfaceSecondary,
                borderColor: AppColors.lightBorder,
                focusedBorderColor: AppColors.primary,
                showPretixIcon: true,
                prefic_icons:  Image.asset(AppAssets.emailIcon, height: 3.h,),
                textColor: AppColors.lightTextPrimary,
                hintTextColor: AppColors.lightTextMuted,
              ),

              SizedBox(height: 4.h),

              /// Reset Button
              AppButtonWidget(
                text: "Send Reset Link",
                width: 100.w,
                height: 6.5.h,
                radius: 16,
                isGradient: true,
                gradientColor: AppColors.buttonGradient,
                onPressed: controller.forgetPassword,
              ),

              SizedBox(height: 8.h),

              /// Login Link
              Column(
                children: [
                  AppText(
                    "Remember your password?",
                    type: AppTextType.caption,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextSecondary,
                  ),
                  SizedBox(height: .8.h),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: AppText(
                      "Log In",
                      type: AppTextType.bodyBold,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
