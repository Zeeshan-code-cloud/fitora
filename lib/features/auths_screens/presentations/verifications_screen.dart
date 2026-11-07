 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_buttons.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text.dart';
import 'controller/auth_controller.dart';

class VerificationScreen extends GetView<AuthController> {
  VerificationScreen({super.key});

  Map<String, String> args = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundSecondary,
      body: SafeArea(
        child: Padding(
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
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              /// Security Icon
              Container(
                height: 16.h,
                width: 16.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.verified_user_outlined,
                    size: 6.h,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              /// Title
              AppText(
                "Verify Your Email",
                type: AppTextType.heading1,
                textAlign: TextAlign.center,
                color: Colors.indigo,
              ),

              SizedBox(height: 1.h),

              /// Subtitle
              AppText(
                "We've sent a verification link to the\n"
                    "below email please check your email inbox\n"
                    "or spam and click the link to verify\n"
                    "click verified button after 5 seconds",
                type: AppTextType.caption,
                color: AppColors.lightTextSecondary,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: .5.h),

              AppText(
                args["email"].toString(),
                type: AppTextType.bodyBold,
                textAlign: TextAlign.center,
                color: AppColors.lightTextPrimary,
              ),

              SizedBox(height: 6.h),

              /// Resend Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Didn't receive code? ",
                    type: AppTextType.caption,
                    color: AppColors.lightTextSecondary,
                  ),
                  GestureDetector(
                    onTap:   () async{
                      await controller.resendVerificationLink();
                      controller.startResendTimer();
                    }  ,
                    child: Obx(
                      () {
                        return AppText(
                          controller.canResend.value ? "Resend email" : "Resend email in ${controller.resendSeconds.value} seconds",
                          type: AppTextType.caption,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// Verify Button
              Obx(
                () {
                  return AppButtonWidget(
                    text: "Verify",
                    loader: controller.isVerifyingEmail.value,
                    width: 100.w,
                    height: 6.5.h,
                    radius: 16,
                    isGradient: true,
                    gradientColor: AppColors.buttonGradient,
                    onPressed: controller.isVerifyingEmail.value ? null :   () async {
                      await controller.verifyEmail();
                    },
                  );
                },
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
