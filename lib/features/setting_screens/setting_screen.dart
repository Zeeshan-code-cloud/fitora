import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/setting_screens/setting_controller.dart';
import 'package:sizer/sizer.dart';


class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 5.h,
                        width: 5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glass,
                          border: Border.all(
                            color: AppColors.glassBorder,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.w),

                    AppText(
                      "Settings",
                      type: AppTextType.heading3,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                /// General
                AppText(
                  "General",
                  type: AppTextType.bodyBold,
                  color: AppColors.textPrimary,
                ),

                SizedBox(height: 1.5.h),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.glassBorder,
                    ),
                  ),
                  child: Column(
                    children: [

                      _notificationTile(
                        value: true,
                        onChanged: (value) {},
                      ),

                      Divider(
                        color: AppColors.glassBorder,
                        height: 1,
                      ),


                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                /// Support
                AppText(
                  "Support",
                  type: AppTextType.bodyBold,
                  color: AppColors.textPrimary,
                ),

                SizedBox(height: 1.5.h),




                /// Logout Button

                SizedBox(height: 4.h),

                /// Version
                Center(
                  child: Column(
                    children: [
                      AppText(
                        "Fitora",
                        type: AppTextType.bodyBold,
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: .5.h),
                      AppText(
                        "Version 1.0.0",
                        type: AppTextType.caption,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _notificationTile({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 1.h,
      ),
      child: Row(
        children: [
          Container(
            height: 5.h,
            width: 5.h,
            decoration: BoxDecoration(
              color: AppColors.glass,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),

          SizedBox(width: 4.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                AppText(
                  "Notifications",
                  type: AppTextType.body,
                  color: AppColors.textPrimary,
                ),

                SizedBox(height: .3.h),

                AppText(
                  "Receive workout reminders",
                  type: AppTextType.micro,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: AppColors.success,
            inactiveThumbColor:
            AppColors.textMuted,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
