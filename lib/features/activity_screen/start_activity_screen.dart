import 'package:fitoraa/features/export.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/theme_controller.dart';

class StartActivityScreen extends GetView<ActivityController> {
  const StartActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          Get.find<ThemeController>().isDarkMode.value;

          return Container(
            width: 100.w,
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
                              color: AppColors.primary,
                            ),
                            child:   Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: AppText(
                              controller.selectedActivity,
                              type: AppTextType.heading4,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            AppText(
                              "GPS",
                              type: AppTextType.caption,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 1.w),
                            Icon(
                              Icons.gps_fixed,
                              size: 14,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                    SizedBox(
                      height: 20.h,
                      child: Obx(
                            () => ListWheelScrollView.useDelegate(
                          physics: controller.startActivityTimer.value
                              ? const NeverScrollableScrollPhysics()
                              : const FixedExtentScrollPhysics(),
                          itemExtent: 50,
                          perspective: 0.005,
                          diameterRatio: 1.5,
                          onSelectedItemChanged: (value) {
                            controller.durationSelected.value = value;
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: controller.activityDurations.length,
                            builder: (context, index) {
                              final isSelected =
                                  controller.durationSelected.value == index;

                              return AppText(
                                controller.activityDurations[index],
                                fontSize: isSelected ? 28 : 20,
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.success
                                    : Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    /// Timer Display
                    Obx(
                          () => AppText(
                        controller.formattedTime,
                        fontSize: 42.sp,
                        color: controller.startActivityTimer.value
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Obx(
                          () => AppText(
                        "Remaining Time",
                        type: AppTextType.body,
                        color: controller.startActivityTimer.value
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(
                          label: "Distance",
                          value: controller.activityDistance,
                          unit: "km",
                          isDouble: true,
                        ),
                        _statItem(
                          label: "Calories",
                          value: controller.activityCalories,
                          unit: "kcal",
                          isDouble: true,
                        ),
                        _statItem(
                          label: "Steps",
                          value: controller.activitySteps,
                          unit: "count",
                          isDouble: false,
                        ),
                      ],
                    ),

                    const Spacer(),

                    /// Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Start/Pause Button
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.startActivity();
                              },
                              child: Container(
                                height: 16.h,
                                width: 16.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.buttonGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(.35),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Obx(() {
                                  return Icon(
                                    controller.startActivityTimer.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 45,
                                  );
                                }),
                              ),
                            ),

                            SizedBox(height: 1.5.h),

                            Obx(() => AppText(
                              controller.startActivityTimer.value ? "Pause" : "Start",
                              type: AppTextType.bodyBold,
                              color: AppColors.textPrimary,
                            )),
                          ],
                        ),

                        SizedBox(width: 10.w),

                        /// Finish Button
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await controller.finishActivity();
                                Get.back();
                              },
                              child: Container(
                                height: 8.h,
                                width: 8.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.glass,
                                  border: Border.all(
                                    color: AppColors.textSecondary.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.stop,
                                  color: AppColors.textPrimary,
                                  size: 26,
                                ),
                              ),
                            ),

                            SizedBox(height: 1.5.h),

                            AppText(
                              "Finish",
                              type: AppTextType.body,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statItem({
    required String label,
    required Rx value,
    required String unit,
    required bool isDouble,
  }) {
    return Column(
      children: [
        Obx(
          () => AppText(
            isDouble ? value.value.toStringAsFixed(2) : value.value.toString(),
            type: AppTextType.heading2,
            color: controller.startActivityTimer.value
                ? AppColors.success
                : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: .5.h),
        AppText(
          label,
          type: AppTextType.caption,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: .3.h),
        AppText(unit, type: AppTextType.micro, color: AppColors.textMuted),
      ],
    );
  }
}
