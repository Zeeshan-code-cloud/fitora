import 'package:fitoraa/features/export.dart';
import 'package:sizer/sizer.dart';
import '../../utils/app_buttons.dart';

class SetTargetScreen extends GetView<HomeController> {
  const SetTargetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.syncGoalCardWithCurrentGoal();
    return Scaffold(
      body: Container(
        decoration:   BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
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
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: AppText(
                          "Set Daily Target",
                          type: AppTextType.heading4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(width: 4.5.h),
                  ],
                ),

                SizedBox(height: 8.h),

                /// Selected Goal Display
                Obx(
                  () => AppText(
                    controller.totalSteps.value.toInt().toString(),
                    type: AppTextType.xlSuperBold,
                    color: AppColors.textPrimary,
                    fontSize: 38.sp,
                  ),
                ),

                SizedBox(height: .5.h),

                AppText(
                  "Steps per day",
                  type: AppTextType.caption,
                  color: AppColors.textSecondary,
                ),

                SizedBox(height: 5.h),

                /// Min / Max Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      "4,000",
                      type: AppTextType.bodyBold,
                      color: AppColors.textSecondary,
                    ),
                    AppText(
                      "25,000",
                      type: AppTextType.bodyBold,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                /// Goal Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 14,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 22,
                    ),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.glassBorder,
                    thumbColor: Colors.white,
                    overlayColor: AppColors.primary.withOpacity(.15),
                  ),
                  child: Obx(
                    () => Slider(
                      value: controller.totalSteps.value.toDouble().clamp(4000.0, 25000.0),
                      min: 4000,
                      max: 25000,
                      divisions: 42, // (25000 - 4000) / 500 = 42
                      onChanged: (value) {
                        controller.updateGoal(value);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 5.h),

                /// Recommended Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    "Recommended",
                    type: AppTextType.bodyBold,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: 2.h),

                /// Goal Recommendation Cards
                Row(
                  children: [
                    Expanded(
                      child: _goalCard(
                        index: 1,
                        icon: Icons.directions_walk,
                        stepsValue: 5000,
                        label: "5,000",
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _goalCard(
                        index: 2,
                        icon: Icons.directions_run,
                        stepsValue: 8000,
                        label: "8,000",
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _goalCard(
                        index: 3,
                        icon: Icons.bolt,
                        stepsValue: 12000,
                        label: "12,000",
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// Save Button
                AppButtonWidget(
                  text: "Save Goal",
                  width: 100.w,
                  height: 6.5.h,
                  radius: 18,
                  isGradient: true,
                  gradientColor: AppColors.buttonGradient,
                  onPressed: controller.saveGoal,
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _goalCard({
    required int index,
    required IconData icon,
    required double stepsValue,
    required String label,
  }) {
    return Obx(() {
      final isSelected = controller.currentGoalCard.value == index;
      return GestureDetector(
        onTap: () {
          controller.selectGoalCard(index, stepsValue);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? AppColors.secondaryCyan : AppColors.glassBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 4.h,
                width: 4.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary.withOpacity(.2) : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.secondaryCyan : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              SizedBox(height: 1.5.h),
              AppText(
                label,
                type: AppTextType.heading3,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: .5.h),
              AppText(
                "steps",
                type: AppTextType.micro,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      );
    });
  }
}
