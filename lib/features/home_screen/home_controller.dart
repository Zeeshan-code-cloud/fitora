import 'dart:async';
import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/core/storage/lacal_db/step_history_model.dart';
 import 'package:fitoraa/features/auths_screens/presentations/controller/auth_controller.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/widgets/app_snackbar.dart';
import 'package:hive/hive.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_permission/smart_permission.dart';
import '../../core/networks/network_controller.dart';
import '../../core/storage/notification_services/notification_services.dart';
import '../../utils/app_buttons.dart';


class HomeController extends GetxController with WidgetsBindingObserver {


  final authC = Get.find<AuthController>();
  // Goals and Progress
  RxDouble totalSteps = 6000.0.obs; // Daily Goal
  RxInt currentSteps = 0.obs; // Daily steps taken
  RxDouble remainingStps = 0.0.obs;
  RxDouble stepPercentValue = 0.0.obs;

  // Stats
  RxDouble callories = 0.0.obs;
  RxDouble currentDistance = 0.0.obs;
  RxInt activeTime = 0.obs;

  // Water
  RxInt totalWalterLiter = 3.obs;
  RxInt currentLiter = 0.obs;
  RxDouble currentWaterLiter = 0.0.obs;

  // UI State
  RxString welcomMessage = "Good Morning".obs;
  RxBool isConnectedInternet = false.obs;
  RxInt currentGoalCard = 0.obs; // Track selected recommended card

  // Pedometer Logic
  StreamSubscription<StepCount>? _stepSubscription;

  ///user profile image
  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    updateGreetings();
    isConnectedInternet.value = NetworkController.to.isConnected.value;
    await loadData();
    await loadWaterData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-initialize pedometer if returning from background/settings and not active
      if (_stepSubscription == null) {
        initPedometer();
      }
    }
  }

  @override
  void onReady() async {
    super.onReady();

    await initPedometer();

    try {
      bool isNotificationEnabled =
          await NotificationServices.requestPermission();

      if (!isNotificationEnabled) {
        await askNotificationPermission();
      }
    } catch (e) {
      debugPrint("Notification permission check error: $e");
    }
  }


  Future<void> loadWaterData() async {
    final prefs = await SharedPreferences.getInstance();

    currentLiter.value = prefs.getInt(Keys.currentLiter) ?? 0;
  }

  Future<void> askNotificationPermission() async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            gradient: AppColors.darkBackgroundGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.glassBorderDark,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Icon
              Container(
                height: 8.h,
                width: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.danger.withOpacity(.15),
                ),
                child: Icon(
                  Icons.notifications,
                  color: AppColors.danger,
                  size: 30.sp,
                ),
              ),

              SizedBox(height: 2.h),

              /// Title
              AppText(
                "Stay Hydrated",
                type: AppTextType.heading3,
                color: AppColors.darkTextPrimary,
              ),

              SizedBox(height: 1.h),

              /// Message
              AppText(
                "To stay hydrated Fitora want to send you notifications to remind you to drink water. ",
                textAlign: TextAlign.center,
                type: AppTextType.body,
                color: AppColors.darkTextSecondary,
              ),

              SizedBox(height: 3.h),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: AppButtonWidget(
                      text: "Not Now",
                      height: 6.h,
                      radius: 16,
                      isGradient: true,
                      gradientColor: AppColors.waterGradient,
                      borderColor: AppColors.glassBorderDark,
                      textColor: AppColors.darkTextPrimary,
                      onPressed: () => Get.back(),
                    ),
                  ),

                  SizedBox(width: 3.w),

                  Expanded(
                    child: AppButtonWidget(
                      text: "Allow",
                      height: 6.h,
                      radius: 16,
                      isGradient: true,
                      gradientColor: AppColors.successGradient,
                      textColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () async {
                        await NotificationServices.requestPermission();
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    totalSteps.value = prefs.getDouble(Keys.goal) ??
        prefs.getDouble(Keys.totalSteps) ??
        6000.0;
    syncGoalCardWithCurrentGoal();

    // Check if the date has changed since last save and handle day reset
    await checkAndHandleDayReset();

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastSavedDate = prefs.getString(Keys.lastSaveDate) ?? "";

    if (lastSavedDate == todayStr) {
      currentSteps.value = prefs.getInt(Keys.currentSteps) ?? 0;
      callories.value = prefs.getDouble(Keys.dailyCalories) ??
          (currentSteps.value * 0.04);
      currentDistance.value = prefs.getDouble(Keys.dailyDistance) ??
          (currentSteps.value * 0.0008);
      activeTime.value = prefs.getInt(Keys.activeTime) ??
          (currentSteps.value ~/ 100);

      // Restore today's saved steps from Hive if available and has newer data
      final box = Hive.isBoxOpen('step_history')
          ? Hive.box<StepHistoryModel>('step_history')
          : null;
      final todayItem = box?.get(todayStr);
      if (todayItem != null && todayItem.steps > currentSteps.value) {
        currentSteps.value = todayItem.steps;
        callories.value = todayItem.calories;
        currentDistance.value = todayItem.distance;
        activeTime.value = todayItem.activeMinutes;
      }

      // If user had steps recorded but stats were zero, re-calculate them
      if (currentSteps.value > 0) {
        if (callories.value == 0.0) callories.value = currentSteps.value * 0.04;
        if (currentDistance.value == 0.0) {
          currentDistance.value = currentSteps.value * 0.0008;
        }
        if (activeTime.value == 0) {
          activeTime.value = (currentSteps.value / 100).floor();
        }
      }

      calculateRemainingSteps();
      stepPercentValue.value = (totalSteps.value > 0
              ? (currentSteps.value / totalSteps.value)
              : 0.0)
          .clamp(0.0, 1.0);
    } else {
      resetTheStates();
      await prefs.setString(Keys.lastSaveDate, todayStr);
    }

    currentLiter.value = prefs.getInt(Keys.currentLiter) ?? 0;
    totalWalterLiter.value = prefs.getInt(Keys.waterGoal) ?? 3;
    _updateWaterPercentage();

    await savePreferences();
  }

  Future<void> checkAndHandleDayReset() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastResetDate = prefs.getString(Keys.lastSaveDate) ?? "";

    if (lastResetDate.isNotEmpty && lastResetDate != todayStr) {
      // Day has changed! Preserve previous day's stats in Hive if not already saved
      final savedSteps = prefs.getInt(Keys.currentSteps) ?? currentSteps.value;
      if (Hive.isBoxOpen("step_history") && savedSteps > 0) {
        final box = Hive.box<StepHistoryModel>("step_history");
        final existing = box.get(lastResetDate);
        if (existing == null || existing.steps < savedSteps) {
          final savedCalories =
              prefs.getDouble(Keys.dailyCalories) ?? (savedSteps * 0.04);
          final savedDistance =
              prefs.getDouble(Keys.dailyDistance) ?? (savedSteps * 0.0008);
          final savedActive =
              prefs.getInt(Keys.activeTime) ?? (savedSteps ~/ 100);
          final prevHistory = StepHistoryModel(
            date: lastResetDate,
            steps: savedSteps,
            calories: savedCalories,
            distance: savedDistance,
            activeMinutes: savedActive,
          );
          await box.put(lastResetDate, prevHistory);
        }
      }

      await prefs.setString(Keys.lastSaveDate, todayStr);
      await prefs.remove('previousEventSteps');
      resetTheStates();
      await savePreferences();
    } else if (lastResetDate.isEmpty) {
      await prefs.setString(Keys.lastSaveDate, todayStr);
    }
  }

  Future<void> initPedometer() async {
    try {
      final res = await SmartPermission.requestResult(
        permission: Permission.activityRecognition,
        description:
            "Physical Activity permission is required to track your daily steps accurately.",
        title: "Permission Required",
      );

      if (res.isGranted) {
        await Future.delayed(const Duration(milliseconds: 300));
        trackSteps();
      } else if (res.isPermanentlyDenied) {
        AppSnackbar.show(
          title: "Permission Required",
          message:
              "Please enable Physical Activity permission from App Settings to track steps.",
        );
      } else {
        AppSnackbar.show(
          title: "Permission Required",
          message: "Activity recognition permission is required to track steps.",
        );
      }
    } catch (e) {
      debugPrint("initPedometer error: $e");
    }
  }

  void trackSteps() {
    _stepSubscription?.cancel();
    _stepSubscription = Pedometer.stepCountStream.listen(
      onStepCount,
      onError: onStepCountError,
      cancelOnError: false,
    );
  }

  void onStepCountError(dynamic error) {
    debugPrint("Pedometer stream error: $error");
  }


  Future<void> onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastSavedDate = prefs.getString(Keys.lastSaveDate) ?? "";

    /// =========================
    /// NEW DAY DETECTED
    /// =========================
    if (lastSavedDate.isNotEmpty && lastSavedDate != todayStr) {
      // Save yesterday's stats to Hive before resetting
      if (Hive.isBoxOpen("step_history") && currentSteps.value > 0) {
        final box = Hive.box<StepHistoryModel>("step_history");
        final existing = box.get(lastSavedDate);
        if (existing == null || existing.steps < currentSteps.value) {
          final prevHistory = StepHistoryModel(
            date: lastSavedDate,
            steps: currentSteps.value,
            calories: callories.value,
            distance: currentDistance.value,
            activeMinutes: activeTime.value,
          );
          await box.put(lastSavedDate, prevHistory);
        }
      }

      await prefs.setString(Keys.lastSaveDate, todayStr);
      resetTheStates();
      await prefs.setInt('previousEventSteps', event.steps);
      await savePreferences();
      return;
    } else if (lastSavedDate.isEmpty) {
      await prefs.setString(Keys.lastSaveDate, todayStr);
    }

    /// =========================
    /// CALCULATE DAILY STEPS
    /// =========================
    int? previousEventSteps = prefs.getInt('previousEventSteps');

    if (previousEventSteps == null) {
      // Set initial baseline for today so subsequent events track delta
      await prefs.setInt('previousEventSteps', event.steps);
      return;
    }

    int stepsAdded = event.steps - previousEventSteps;

    /// Device reboot / sensor reset
    if (stepsAdded < 0) {
      stepsAdded = event.steps;
    }

    await prefs.setInt('previousEventSteps', event.steps);

    /// =========================
    /// UPDATE UI VALUES & PERSIST
    /// =========================
    if (stepsAdded > 0) {
      currentSteps.value += stepsAdded;
      _calculateMetrics();
      await savePreferences();
      await saveTodayStates();
      update();
    }
  }

  void _calculateMetrics() {
    callories.value = currentSteps.value * 0.04;
    currentDistance.value = currentSteps.value * 0.0008;
    activeTime.value = (currentSteps.value / 100).floor();
    calculateRemainingSteps();
    stepPercentValue.value = (totalSteps.value > 0
            ? (currentSteps.value / totalSteps.value)
            : 0.0)
        .clamp(0.0, 1.0);
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(Keys.goal, totalSteps.value);
    await prefs.setDouble(Keys.totalSteps, totalSteps.value);
    await prefs.setInt(Keys.currentSteps, currentSteps.value);
    await prefs.setDouble(Keys.remainingSteps, remainingStps.value);
    await prefs.setDouble(Keys.dailyCalories, callories.value);
    await prefs.setDouble(Keys.dailyDistance, currentDistance.value);
    await prefs.setInt(Keys.activeTime, activeTime.value);
    await prefs.setDouble(Keys.todayProgress, stepPercentValue.value);

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    await prefs.setString(Keys.lastSaveDate, todayStr);
  }

  Future<void> saveTodayStates() async {
    if (!Hive.isBoxOpen("step_history")) return;
    final box = Hive.box<StepHistoryModel>("step_history");
    final now = DateTime.now();
    final key = "${now.year}-${now.month}-${now.day}";

    final stepHistory = StepHistoryModel(
      date: key,
      steps: currentSteps.value,
      calories: callories.value,
      distance: currentDistance.value,
      activeMinutes: activeTime.value,
    );
    await box.put(key, stepHistory);
  }



  double getYesterdayPercentageChange() {
    final box = Hive.box<StepHistoryModel>("step_history");
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final key = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
    final item = box.get(key);
    final yesterdaySteps = item?.steps ?? 0;

    if (yesterdaySteps <= 0) {
      return currentSteps.value > 0 ? 100.0 : 0.0;
    }
    return (((currentSteps.value - yesterdaySteps) / yesterdaySteps) * 100);
  }

  void resetTheStates() {
    currentSteps.value = 0;
    remainingStps.value = totalSteps.value;
    stepPercentValue.value = 0.0;
    callories.value = 0.0;
    currentDistance.value = 0.0;
    activeTime.value = 0;
    currentLiter.value = 0;
    _updateWaterPercentage();
    update();
  }

  void updateGreetings() {
    final hours = DateTime.now().hour;
    if (hours >= 0 && hours < 12) {
      welcomMessage.value = "Good Morning";
    } else if (hours >= 12 && hours < 17) {
      welcomMessage.value = "Good Afternoon";
    } else if (hours < 21) {
      welcomMessage.value = "Good Evening";
    } else {
      welcomMessage.value = "Good Night";
    }
  }

  void calculateRemainingSteps() {
    double remaining = totalSteps.value - currentSteps.value;
    remainingStps.value = remaining > 0 ? remaining : 0.0;
  }

  void syncGoalCardWithCurrentGoal() {
    final steps = totalSteps.value.toInt();
    if (steps == 5000) {
      currentGoalCard.value = 1;
    } else if (steps == 8000) {
      currentGoalCard.value = 2;
    } else if (steps == 12000) {
      currentGoalCard.value = 3;
    } else {
      currentGoalCard.value = 0;
    }
  }

  void updateGoal(double value) {
    totalSteps.value = value.roundToDouble();
    syncGoalCardWithCurrentGoal();
    calculateRemainingSteps();
    stepPercentValue.value = (totalSteps.value > 0
            ? (currentSteps.value / totalSteps.value)
            : 0.0)
        .clamp(0.0, 1.0);
  }

  void selectGoalCard(int index, double stepsValue) {
    currentGoalCard.value = index;
    totalSteps.value = stepsValue;
    calculateRemainingSteps();
    stepPercentValue.value = (totalSteps.value > 0
            ? (currentSteps.value / totalSteps.value)
            : 0.0)
        .clamp(0.0, 1.0);
  }

  void _updateWaterPercentage() {
    if (totalWalterLiter.value > 0) {
      currentWaterLiter.value = (currentLiter.value / totalWalterLiter.value)
          .clamp(0.0, 1.0);
    } else {
      currentWaterLiter.value = 0.0;
    }
  }

  Future<void> setWaterGoal(int goal) async {
    totalWalterLiter.value = goal;
    _updateWaterPercentage();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Keys.waterGoal, goal);
  }

  Future<void> saveGoal() async {
    calculateRemainingSteps();
    stepPercentValue.value = (totalSteps.value > 0
            ? (currentSteps.value / totalSteps.value)
            : 0.0)
        .clamp(0.0, 1.0);
    await savePreferences();

    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.bottomNavScreen);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stepSubscription?.cancel();
    super.onClose();
  }
}
