import 'package:fitoraa/utils/app_buttons.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/theme_controller.dart';
import '../export.dart';

class OnboardingScreen extends GetView<OnboardingController> {
    OnboardingScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundSecondary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
          child: Column(
            children: [
              SizedBox(height: 5.h),
              Obx(() {
                return controller.currentIndex.value == 0
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: controller.getStarted,
                          child: Container(

                            height: 6.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                               borderRadius: BorderRadius.circular(12),
                              border: BoxBorder.all(
                                color: AppColors.border.withOpacity(0.3),
                              ),

                            ),
                            child: Center(
                              child: AppText(
                                "Skip",
                                color: AppColors.darkTextPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 6.h, width: 15.w);
              }),
              SizedBox(
                width: double.infinity,
                height: 67.h,
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.onboardingImages.length,
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentIndex.value = index;
                  },
                  itemBuilder: (context, index) {
                    final image = controller.onboardingImages[index];
                    final title = controller.onboardingTitles[index];
                    final des = controller.onboadingDes[index];
                    return Column(
                      children: [
                        Image.asset(height: 50.h, fit: BoxFit.cover, image),
                        SizedBox(height: 1.h),
                        AppText(
                          title,
                          color: AppColors.lightTextPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: AppText(
                            des,
                            color: AppColors.lightTextSecondary.withOpacity(0.44),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.only(left: 35.w),
                child: Row(
                  children: List.generate(controller.onboardingImages.length, (
                    index,
                  ) {
                    return Obx(() {
                      final currentIndex =
                          controller.currentIndex.value == index;

                      return AnimatedContainer(
                        margin: EdgeInsets.all(0.6.w),
                        width: currentIndex ? 8.w : 4.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: currentIndex
                              ? AppColors.primary
                              : AppColors.white,
                          border: BoxBorder.all(
                            color: AppColors.border.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        duration: Duration(milliseconds: 500),
                      );
                    });
                  }),
                ),
              ),
              SizedBox(height: 3.h),
              Obx(() {
                return controller.currentIndex.value == 0
                    ? AppButtonWidget(
                        onPressed:
                            controller.currentIndex.value <
                                controller.onboardingImages.length - 1
                            ? controller.nextPage
                            : controller.getStarted,
                        width: double.infinity,
                        height: 8.h,
                        radius: 4.w,
                        isGradient: true,
                        gradientColor: AppColors.buttonGradient,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                        text: "Next",
                      )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child:
                          Obx(
                    () {
                      return AppButtonWidget(text: "Back",
                        onPressed: controller.currentIndex.value != 0 ? controller.previousPage : null,
                        textColor: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        width: double.infinity,
                        height: 8.h,
                        buttonColor: AppColors.white,
                        radius: 16,
                      );
                    },
                          ),
                          ),
                          SizedBox(width: 2.w,),
                          Obx(
                (){
                  return Expanded(child:
                  AppButtonWidget(text: controller.currentIndex.value < controller.onboardingImages.length - 1 ? "Next" : "Get Started",
                    onPressed: controller.currentIndex.value < controller.onboardingImages.length -1?  controller.nextPage : controller.getStarted,
                    width: double.infinity,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 8.h,
                    isGradient: true,
                    gradientColor: AppColors.buttonGradient,
                    radius: 20,
                  ),
                  );
                },
                          ),
                        ],
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
