import 'dart:math';

import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/utils/app_assets.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  RxInt currentIndex = 0.obs;
  PageController pageController = PageController();

  List<String> onboardingImages = [
    AppAssets.onboardingImage,
    AppAssets.onboardingImage1,
    AppAssets.onboardingImage2,
  ];

  List<String> onboardingTitles = [
    "Every Steps Counts",
    "Stay Hydrated",
    "Move Your Way",
  ];

  List<String> onboadingDes = [
    "Track your daily movement and stay on course with goal that fit your lifestyle",
    "Build better hydration habits with smart reminders throughout your day",
    "Log workout and track progress and understand up how your daily activity adds up",
  ];

  Future getStarted() async {
     final prefs = await SharedPreferences.getInstance();
    prefs.setBool(Keys.isFirstLaunch, false);
    Get.offAllNamed(AppRoutes.signInScreen);
  }

   void nextPage() {
     pageController.nextPage(
       duration: Duration(milliseconds: 500),
       curve: Curves.easeInOut,
     );
  }

  void previousPage() {
    pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
}
