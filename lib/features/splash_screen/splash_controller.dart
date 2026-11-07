import 'package:fitoraa/core/networks/network_banner.dart';
import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auths_screens/presentations/controller/auth_controller.dart';
import '../export.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;

  @override
  void onInit() {
    super.onInit();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      );
      animation = Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
      );
      animationController.forward();
    handleNavigation();
  }

  Future handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    // Defaults to true so first-time users see onboarding
    final isFirstLaunch = prefs.getBool(Keys.isFirstLaunch) ?? true;

    // Delay to allow splash animation to complete
    await Future.delayed(const Duration(milliseconds: 1200));

    if (isFirstLaunch) {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    } else {
      final authC = Get.find<AuthController>();
      await authC.getCurrentUserSessionMethod();
      if (authC.currentUser.value != null) {
        Get.toNamed(AppRoutes.bottomNavScreen);
      } else {
        Get.offAllNamed(AppRoutes.signInScreen);
      }
      // else {
        // final authC = Get.find<AuthController>();
        // await authC.getCurrentUserSessionMethod();
        // if (authC.currentUser.value != null) {
        //   Get.offAllNamed(AppRoutes.bottomNavScreen);
        // } else {
        //   Get.offAllNamed(AppRoutes.signInScreen);
        // }
      // }
    }
  }
}
