

import 'package:fitoraa/utils/app_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_buttons.dart';
import '../../../utils/app_text_field.dart';
import '../../export.dart';
 import 'controller/auth_controller.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundSecondary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 4.h),

              /// Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 7.2.h,
                    width: 7.2.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(AppAssets.appLogo))
                    ),

                  ),
                  SizedBox(width: 2.w),
                  AppText(
                    "Fitora",
                    fontSize: 30,
                    color: AppColors.lightTextPrimary,
                    type: AppTextType.heading2,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              /// Title
              AppText(
                "Create Your Account",
                color: AppColors.lightTextSecondary,
                type: AppTextType.heading1,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.h),

              AppText(
                "Start building healthier\nhabits today.",
                type: AppTextType.caption,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),

              SizedBox(height: 4.h),

              /// Full Name
              Form(
                  key: controller.formKey,
                  child: Column(children: [
                AppFormField(
                title: "Full Name",
                validator:  (value){
                  if(value == null || value.trim().isEmpty){
                    return "name are required";
                  }
                  final name = value.trim();
                  if(name.length <3){
                    return "character must be 3 or greater";
                  }
                  return null;
                },
                textEditingController: controller.fullNameController,
                showBorder: true,
                isFilled: true,
                filledColor: AppColors.lightSurfaceSecondary,
                borderColor: AppColors.lightBorder,
                focusedBorderColor: AppColors.primary,
                showPretixIcon: true,
                prefic_icons: Image.asset(AppAssets.personIcon,height: 3.h,),
                preficIconwidth: 5.w,
                textColor: AppColors.lightTextSecondary,
                hintTextColor: AppColors.textMuted,
              ),

                SizedBox(height: 1.8.h),

                /// Email
                AppFormField(
                  validator:  (value){
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
                  title: "Email address",
                  textEditingController: controller.emailController,
                  textInputType: TextInputType.emailAddress,
                  showBorder: true,
                  isFilled: true,
                  filledColor: AppColors.lightSurfaceSecondary,
                  borderColor: AppColors.lightBorder,
                  focusedBorderColor: AppColors.primary,
                  showPretixIcon: true,
                  prefic_icons:Image.asset(AppAssets.emailIcon,height: 3.h,),
                  preficIconwidth: 5.w,
                  textColor: AppColors.lightTextPrimary,
                  hintTextColor: AppColors.textMuted,
                ),

                SizedBox(height: 1.8.h),

                /// Password
                Obx(
                      () =>  AppFormField(
                    title: "Password",
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "password are required";
                      }
                      else if(value.length < 6){
                        return "character must be at least 6";
                      }
                      return null;
                    },
                    textEditingController: controller.passwordController,
                    isObsecured: controller.isPasswordVisible.value,
                    showBorder: true,
                    isFilled: true,
                    filledColor: AppColors.lightSurfaceSecondary,
                    borderColor: AppColors.lightBorder,
                    focusedBorderColor: AppColors.primary,
                    iconWidget: GestureDetector(
                        onTap: controller.toggledPassword,
                        child: Icon(
                          controller.isPasswordVisible.value ?  Icons.visibility_off_outlined : Icons.visibility_outlined,

                          color: AppColors.lightTextSecondary,
                        )),
                    showPretixIcon: true,
                    preficIconwidth: 5.w,
                    prefic_icons: Image.asset(AppAssets.lockIcon, height: 3.h,),
                    textColor: AppColors.lightTextPrimary,
                    hintTextColor: AppColors.textMuted,
                  ),
                ),

                SizedBox(height: 1.8.h),

                /// Confirm Password
                Obx(()
                =>  AppFormField(
                  title: "Confirm Password",
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return "password are required";
                    }
                    else if (value.length < 6) {
                      return "character must be at least 6";
                    }
                    return null;
                  },
                  textEditingController: controller.confirmPasswordController,
                  isObsecured: controller.isPasswordVisible.value,
                  showBorder: true,
                  isFilled: true,
                  filledColor: AppColors.lightSurfaceSecondary,
                  preficIconwidth: 5.w,
                  borderColor: AppColors.lightBorder,
                  focusedBorderColor: AppColors.primary,
                  showPretixIcon: true,
                  prefic_icons: Image.asset(AppAssets.lockIcon,height: 3.h,),
                  iconWidget: GestureDetector(

                    onTap : controller.toggledPassword,
                    child: Icon(
                      controller.isPasswordVisible.value ?  Icons.visibility_off_outlined : Icons.visibility_outlined,

                      color: AppColors.textSecondary,
                    ),
                  ),
                  textColor: AppColors.lightTextPrimary,
                  hintTextColor: AppColors.textMuted,
                ),
                ),
              ],)),
              SizedBox(height: 2.h),

              /// Terms & Conditions

        Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: Obx(
                    () => Checkbox(
                      side: BorderSide(color: AppColors.lightTextPrimary),
                  value: controller.isTerAccepted.value,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    controller.isTerAccepted.value = value ?? false;
                  },
                ),
              )
            ),
            SizedBox(width: 3.w),

            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(
                      text: 'I agree to the ',
                    ),

                    TextSpan(
                      text: 'Terms of Service',
                      style:   TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async  {
                         await  controller.launchToWeb("https://zeeshan-code-cloud.github.io/fitora_terms/");
                        },
                    ),

                    const TextSpan(
                      text: ' and ',
                    ),

                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async  {
                        await controller.launchToWeb("https://zeeshan-code-cloud.github.io/fitora_privacy/");
                        },
                    ),

                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

              SizedBox(height: 3.h),

              /// Create Account Button
              Obx(
                () {
                  return AppButtonWidget(
                    loader: controller.isRegistering.value,
                    text: "Create Account",
                    width: 100.w,
                    height: 6.5.h,
                    radius: 16,
                    isGradient: true,
                    gradientColor: AppColors.buttonGradient,
                    onPressed: controller.registerUser,
                  );
                },
              ),



              SizedBox(height: 4.h),

              /// Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Already have an account? ",
                    type: AppTextType.caption,
                    color: AppColors.textSecondary,
                  ),
                  GestureDetector(
                    onTap: controller.moveToLoginScreen,
                    child: AppText(
                      "Log In",
                      type: AppTextType.caption,
                      fontWeight: FontWeight.w700,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }
}
