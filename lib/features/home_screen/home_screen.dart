import 'dart:io';

import 'package:fitoraa/utils/app_assets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import '../export.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  final profileC = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),

                  // Header Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => AppText(
                                controller.welcomMessage.value,
                                type: AppTextType.captionDark,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: .5.h),
                            Obx(
                              () {
                                final user = controller.authC.currentUser.value;
                                if (user == null) {
                                  return SizedBox(
                                    width: 4.w,
                                    height: 2.h,
                                    child: const CircularProgressIndicator(),
                                  );
                                }
                                return AppText(
                                  user.fullName,
                                  type: AppTextType.heading1,
                                  color: AppColors.textPrimary,
                                );
                              },
                            ),
                            SizedBox(height: .5.h),
                            AppText(
                              "Ready to move today?",
                              type: AppTextType.captionDark,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),

                      // Profile Avatar
                      Container(
                        height: 7.h,
                        width: 7.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Obx(() {
                          if (profileC.profileImage.value.isNotEmpty &&
                              File(profileC.profileImage.value).existsSync()) {
                            return CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white.withValues(alpha: 0.1),
                              backgroundImage:
                                  FileImage(File(profileC.profileImage.value)),
                            );
                          }
                          return ClipOval(
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(AppAssets.profileAvatar),
                          );
                        }),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),
                  Divider(color: AppColors.divider),
                  SizedBox(height: 3.h),

                  /// Step Progress Circle
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.stepScreen);
                      },
                      child: Obx(
                        () => CircularPercentIndicator(
                          radius: 12.h,
                          lineWidth: 10,
                          percent: controller.stepPercentValue.value,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: AppColors.secondaryCyan,
                          backgroundColor: AppColors.border,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                controller.currentSteps.value.toString(),
                                type: AppTextType.xlSuperBold,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 0.5.h),
                              AppText(
                                "Steps",
                                type: AppTextType.body,
                                color: AppColors.textPrimary,
                              ),
                              SizedBox(height: 0.5.h),
                              AppText(
                                controller.totalSteps.value.toInt().toString(),
                                type: AppTextType.caption,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 1.3.h),

                  Center(
                    child: Obx(
                      () => AppText(
                        "${controller.remainingStps.value.toInt()} steps left",
                        type: AppTextType.caption,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.4.h),

                  /// Stats Cards (Calories, Distance, Active Time)
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => _statCard(
                            title: "Calories",
                            value: controller.callories.value,
                            unit: "kcal",
                            fractionDigits: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Obx(
                          () => _statCard(
                            title: "Distance",
                            value: controller.currentDistance.value,
                            unit: "km",
                            fractionDigits: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Obx(
                          () => _statCard(
                            title: "Active",
                            value: controller.activeTime.value.toDouble(),
                            unit: "min",
                            fractionDigits: 0,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  /// Water Intake Card
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.setWaterReminder);
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.glassBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "Water Intake",
                                  type: AppTextType.bodyBold,
                                  color: AppColors.textPrimary,
                                ),
                                SizedBox(height: 2.h),
                                Obx(
                                  () => RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: controller.currentLiter.value
                                              .toString(),
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "/${controller.totalWalterLiter.value.toString()} Liter",
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Obx(
                                    () {
                                      final double progress =
                                          controller.totalWalterLiter.value > 0
                                              ? controller.currentLiter.value /
                                                  controller.totalWalterLiter.value
                                              : 0.0;
                                      return LinearProgressIndicator(
                                        value: progress.clamp(0.0, 1.0),
                                        minHeight: 4.h,
                                        color: AppColors.secondaryCyan,
                                        backgroundColor: AppColors.divider,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Image.asset(
                            AppAssets.waterBottle,
                            height: 18.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required double value,
    required String unit,
    int fractionDigits = 1,
  }) {
    final displayValue = fractionDigits == 0
        ? (value > 0 && value < 10
            ? value.toStringAsFixed(1)
            : value.toInt().toString())
        : value.toStringAsFixed(fractionDigits);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.glassBorder,
        ),
      ),
      child: Column(
        children: [
          AppText(
            title,
            type: AppTextType.micro,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 1.h),
          AppText(
            displayValue,
            type: AppTextType.heading2,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: .5.h),
          AppText(
            unit,
            type: AppTextType.micro,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}
