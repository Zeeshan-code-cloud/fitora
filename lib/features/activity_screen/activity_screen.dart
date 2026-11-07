
import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_buttons.dart';
import '../export.dart';

class ActivityScreen extends GetView<ActivityController> {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        (){
          Get.find<ThemeController>().isDarkMode.value;

          return Container(
            width: 100.w,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),

                    /// Title
                    AppText(
                      "What are you\ndoing today?",
                      type: AppTextType.heading2,
                      color: AppColors.textPrimary,
                    ),

                    SizedBox(height: 4.h),

                    /// Activities Grid
                    Expanded(
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.w,
                        mainAxisSpacing: 2.h,
                        childAspectRatio: 1.15,
                        children: [
                          _activityCard(
                            index: 1,
                            title: "Running",
                            icon: Icons.directions_run,

                          ),

                          _activityCard(
                            index: 2,
                            title: "Walking",
                            icon: Icons.directions_walk,
                          ),

                          _activityCard(
                            index: 3,
                            title: "Cycling",
                            icon: Icons.pedal_bike,
                          ),

                          _activityCard(
                            index: 6,
                            title: "Swimming",
                            icon: Icons.pool,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    /// Button
                    AppButtonWidget(
                      text: "Start Activity",
                      width: 100.w,
                      height: 6.5.h,
                      radius: 18,
                      isGradient: true,
                      gradientColor: AppColors.buttonGradient,
                      onPressed: () {
                        Get.toNamed(AppRoutes.startActivity);
                      },
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _activityCard({
    required int index,
    required String title,
    required IconData icon,
   }) {
    return Obx(
        ( ){
           final isSelected = controller.currentActivity.value == index;
          return GestureDetector(
            onTap: () {
              controller.currentActivity.value = index;
              controller.selectedActivity = title;
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondaryCyan
                      : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: AppColors.secondaryCyan
                        .withOpacity(.15),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: isSelected
                        ? AppColors.secondaryCyan
                        : AppColors.textPrimary,
                  ),

                  SizedBox(height: 2.h),

                  AppText(
                    title,
                    type: AppTextType.bodyBold,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
