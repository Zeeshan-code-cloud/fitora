import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/water_reminder_screen/set_water_reminder_controller.dart';
import 'package:fitoraa/utils/app_assets.dart';
 import 'package:sizer/sizer.dart';
import '../../utils/app_buttons.dart';

class WaterReminderScreen extends GetView<SetWaterReminderController> {
  const WaterReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:   BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              children: [
                /// Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 4.5.h,
                        width: 4.5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glass,
                        ),
                        child:   Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: AppText(
                          "Hydration",
                          type: AppTextType.heading4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.5.h),
                  ],
                ),

                SizedBox(height: 2.h),

                /// Progress Circle
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 7.h,
                    width: 7.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryCyan,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Obx(() {
                        final int goal = controller.homeC.totalWalterLiter.value;
                        final int current = controller.homeC.currentLiter.value;
                        final int percent = goal > 0
                            ? ((current / goal) * 100).clamp(0, 100).toInt()
                            : 0;
                        return AppText(
                          "$percent%",
                          type: AppTextType.micro,
                          color: AppColors.secondaryCyan,
                          fontWeight: FontWeight.bold,
                        );
                      }),
                    ),
                  ),
                ),

                /// Bottle
                Expanded(
                  child: Center(
                    child: Image.asset(
                      AppAssets.waterBottle,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                /// Water Amount & Goal
                Obx(() {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AppText(
                            controller.homeC.currentLiter.value.toString(),
                            type: AppTextType.xlSuperBold,
                            color: AppColors.textPrimary,
                            fontSize: 34.sp,
                          ),
                          AppText(
                            " / ${controller.homeC.totalWalterLiter.value} L",
                            type: AppTextType.heading3,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.8.h),
                      GestureDetector(
                        onTap: controller.showGoalPicker,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.5.w,
                            vertical: 0.6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.glass,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 12.sp,
                                color: AppColors.secondaryCyan,
                              ),
                              SizedBox(width: 1.5.w),
                              AppText(
                                "Daily Goal: ${controller.homeC.totalWalterLiter.value}L",
                                type: AppTextType.captionDark,
                                color: AppColors.secondaryCyan,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: 2.h),

                /// Smart Breakdown Card
                Obx(() {
                  return Container(
                    padding: EdgeInsets.all(3.5.w),
                    decoration: BoxDecoration(
                      color: AppColors.glass,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondaryCyan.withOpacity(0.15),
                          ),
                          child: Icon(
                            Icons.water_drop_rounded,
                            color: AppColors.secondaryCyan,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                "Smart Hydration Plan",
                                type: AppTextType.bodyBold,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 0.3.h),
                              AppText(
                                "Drink ~${controller.intakePerReminderFormatted} (${controller.glassesFormatted}) every ${controller.selectedIntervalText} (8 AM – 10 PM)",
                                type: AppTextType.captionDark,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 1.5.h),

                /// Reminder Card
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              "Water Reminders",
                              type: AppTextType.bodyBold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          Obx(() {
                            return Switch(
                              value: controller.reminderEnabled.value,
                              activeColor: AppColors.success,
                              onChanged: (value) {
                                controller.toggleReminder(value);
                              },
                            );
                          }),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      GestureDetector(
                        onTap: () {
                          controller.showIntervalPicker();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.8.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  return AppText(
                                    "You will notify after every ${controller.selectedIntervalText} (8 AM – 10 PM)",
                                    type: AppTextType.captionDark,
                                    color: AppColors.textPrimary,
                                  );
                                }),
                              ),

                                Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
