import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:fitoraa/features/botton_nav_bar/bottom_nav_bar_controller.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:fitoraa/utils/show_custom_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_buttons.dart';

class BottomNavBar extends GetView<BottomNavBarController> {
    BottomNavBar({super.key});

  final themeC = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(didPop){
          return;
        }
      ShowCustomDialog.showCustomDialog(
        context: context,
        icon: Icons.exit_to_app_rounded,
        iconColor: Colors.orange,
        title: "Exit App?",
        content: "Are you sure you want to close the application?",
        cancelText: "Stay",
        confirmText: "Exit",
        confirmButtonColor: Colors.orange,
        confirmTextColor: Colors.white,
        onConfirm: () {
          Navigator.pop(context);
          SystemNavigator.pop();
        },
      );

       },

      child: Scaffold(
         body: Obx(
              () {
                Get.find<ThemeController>().isDarkMode.value;

                return  IndexedStack(
                  index: controller.currentIndex.value,
                  children: controller.pages
                      .map((page) => page())
                      .toList(),
                );
              }
        ),

        bottomNavigationBar: Obx(
          () {
            return Container(

              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 1.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,

                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    index: 0,
                    title: "Home",
                    icon:  controller.currentIndex.value == 0 ?  AppAssets.activeHomeIcon : AppAssets.homeIcon,
                  ),
                  _navItem(
                    index: 1,
                    title: "Activity",
                    icon: controller.currentIndex.value == 1 ? AppAssets.activeActivityIcon : AppAssets.activityIcon,
                  ),
                  _navItem(
                    index: 2,
                    title: "History",
                    icon: controller.currentIndex.value == 2 ?AppAssets.activeHistoryIcon :  AppAssets.historyIcon,
                  ),
                  _navItem(
                    index: 3,
                    title: "Profile",
                    icon: controller.currentIndex.value == 3 ? AppAssets.activeProfileIcon :  AppAssets.profileIcon,
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String title,
    required String icon,
  }) {
    final bool isSelected = controller.currentIndex.value  == index;

    return GestureDetector(
      onTap: () {
        controller.currentIndex.value = index;

      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(14),
          gradient: isSelected ? AppColors.buttonGradient : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: 3.4.h,
              width: 6.4.h,

            ),

            SizedBox(height: .5.h),

            AppText(
              title,
              type: AppTextType.micro,
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}


