import 'package:fitoraa/features/auths_screens/presentations/controller/auth_controller.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/app_buttons.dart';
import '../../../utils/app_text_field.dart';
import '../../export.dart';



class SigninScreen extends GetView<AuthController> {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 100.h,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 8.h),
            
                  /// Logo
                  SizedBox(
                    height: 10.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 8.2.h,
                          width: 7.2.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(AppAssets.appLogo, ),fit: BoxFit.cover)
                          ),
            
                        ),
                        SizedBox(width: 2.w),
                        AppText(
                          "Fitora",
                          type: AppTextType.heading2,
                          color: AppColors.lightTextSecondary,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
            
                  SizedBox(height: 3.h),
            
                  /// Welcome Text
                  AppText(
                    "Welcome Back",
                    type: AppTextType.heading1,
                    textAlign: TextAlign.center,
                    color: AppColors.lightTextSecondary,
                  ),
            
                  SizedBox(height: 0.8.h),
            
                  AppText(
                    "Your progress is waiting for you.",
                    type: AppTextType.caption,
                    textAlign: TextAlign.center,
                    color: AppColors.textSecondary,
                  ),
            
                  SizedBox(height: 5.h),
            
                  /// Email
                  AppFormField(
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

                    title: "Email address",
                    textEditingController: controller.emailController,
                    showBorder: true,
                    isFilled: true,
                    filledColor: AppColors.lightSurfaceSecondary,
                    borderColor: AppColors.lightBorder,
                    focusedBorderColor: AppColors.primary,
                    showPretixIcon: true,
                    preficIconwidth: 6.w,
                    prefic_icons: Image.asset(AppAssets.emailIcon, height: 3.h,),
                    hintTextColor: AppColors.lightTextSecondary,
                    textColor: AppColors.lightTextPrimary,
                  ),
            
                  SizedBox(height: 2.h),
            
                  /// Password
                  Obx(
                    () =>  AppFormField(
                      title: "Password",
                      preficIconwidth: 6.w,
                      textEditingController: controller.passwordController,
                      isObsecured: controller.isPasswordVisible.value,
                      showBorder: true,
                      isFilled: true,
                      filledColor: AppColors.lightSurfaceSecondary,
                      borderColor: AppColors.lightBorder,
                      focusedBorderColor: AppColors.primary,
                      showPretixIcon: true,

                      prefic_icons: Image.asset(
                        height: 3.h,
                          AppAssets.lockIcon),
                      iconWidget: GestureDetector(
                        onTap: controller.toggledPassword,
                        child: Icon(
                       controller.isPasswordVisible.value ?  Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      hintTextColor: AppColors.lightTextSecondary,
                      textColor: AppColors.lightTextPrimary,
                    ),
                  ),
            
                  SizedBox(height: 1.5.h),
            
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: controller.moveToForgetPasswordScreen,
                      child: AppText(
                        "Forgot Password?",
                        type: AppTextType.captionDark,
                        color: AppColors.black,
                      ),
                    ),
                  ),
            
                  SizedBox(height: 4.h),
            
                  /// Login Button
                  Obx(
                    (){
                      return AppButtonWidget(
                        loader: controller.isLogging.value,
                        text: "Log In",
                        width: 100.w,
                        height: 6.5.h,
                        radius: 16,
                        isGradient: true,
                        gradientColor: AppColors.buttonGradient,
                        onPressed: controller.loginUser,
                      );
                    },
                  ),
            

            
                  SizedBox(height: 3.h),
            
                  /// Google Button
                  const Spacer(),
            
                  /// Sign Up
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          "Don't have an account? ",
                          type: AppTextType.caption,
                          color: AppColors.textSecondary,
                        ),
                        GestureDetector(
                          onTap: controller.moveToSignUpScreen,
                          child: AppText(
                            "Sign Up",
                            type: AppTextType.caption,
                            color: AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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
