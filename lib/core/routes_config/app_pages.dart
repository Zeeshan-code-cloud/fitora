


import 'package:fitoraa/features/activity_screen/start_activity_screen.dart';
import 'package:fitoraa/features/botton_nav_bar/bottom_nav_binding.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/setting_screens/setting_binding.dart';
import 'package:fitoraa/features/steps_screen/set_target_screen.dart';
import 'package:fitoraa/features/steps_screen/steps_screen_binding.dart';
import 'package:fitoraa/features/water_reminder_screen/set_water_reminder_binding.dart';
import 'package:fitoraa/features/water_reminder_screen/water_reminder_screen.dart';

import '../../features/botton_nav_bar/bottom_nav_bar.dart';
import '../../features/setting_screens/setting_screen.dart';
import '../../features/steps_screen/steps_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => OnboardingScreen(),
      binding: OnboadingBinding(),
    ),
    GetPage(
      name: AppRoutes.signInScreen,
      page: () => SigninScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => VerificationScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.historyScreen,
      page: () => HistoryScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.activityScreen,
      page: () => ActivityScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => ProfileScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.bottomNavScreen,
      page: () => BottomNavBar(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: AppRoutes.setTargetScreen,
      page: () => SetTargetScreen(),
      binding: StepsScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.stepScreen,
      page: () => StepsScreen(),
      binding: StepsScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.setWaterReminder,
      page: () => WaterReminderScreen(),
      binding: SetWaterReminderBinding(),
    ),
    GetPage(
      name: AppRoutes.startActivity,
      page: () => StartActivityScreen(),
      binding: ActivityBinding(),
    ),
    GetPage(
      name: AppRoutes.settingScreen,
      page: () => SettingScreen(),
      binding: SettingBinding(),
    ),
  ];
}
