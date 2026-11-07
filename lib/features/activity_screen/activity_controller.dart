import 'dart:async';

import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/history_screen/history_controller.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityController extends GetxController {
  final homeC = Get.find<HomeController>();

  RxInt currentActivity = 1.obs;
  String selectedActivity = "Running";
  RxBool startActivityTimer = false.obs;
  RxInt durationSelected = 0.obs;

  RxDouble activityDistance = 0.0.obs;
  RxDouble activityCalories = 0.0.obs;
  RxDouble activityHearBeat = 0.0.obs;
  RxInt activitySteps = 0.obs;
  StreamSubscription? stepStreams;
  Timer? activityTimer;

  RxInt remainingSeconds = 0.obs;

  int startSteps = 0;
  int currentSteps = 0;

  List<String> activityDurations = [
    "30 minutes",
    "45 minutes",
    "60 minutes",
    "75 minutes",
    "90 minutes",
    "105 minutes",
    "120 minutes",
  ];

  int getSelectedDurationSeconds() {
    final text = activityDurations[durationSelected.value];
    // Trim to handle the space after removing "minutes"
    final minutes = int.parse(
      text.replaceAll("minutes", "").trim(),
    );
    return minutes * 60;
  }

  Future<void> startActivity() async {
    if (startActivityTimer.value) {
      pauseActivity();
    } else {
      await startTimer();
    }
  }

  Future<void> startTimer() async {
    startActivityTimer.value = true;

    // Only set the duration if the timer is at 0 (fresh start)
    if (remainingSeconds.value <= 0) {
      remainingSeconds.value = getSelectedDurationSeconds();
      // Reset session stats
      activitySteps.value = 0;
      activityDistance.value = 0.0;
      activityCalories.value = 0.0;
      startSteps = 0;
    }

    stepStreams ??= Pedometer.stepCountStream.listen(
      recognizedMovements,
      onError: onRecognitionError,
    );

    activityTimer?.cancel();
    activityTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          finishActivity();
        }
      },
    );
  }

  void pauseActivity() {
    activityTimer?.cancel();
    startActivityTimer.value = false;
  }

  String get formattedTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  void recognizedMovements(StepCount event) {
    // Only count steps if the timer is actually running
    if (!startActivityTimer.value) return;

    currentSteps = event.steps;

    if (startSteps == 0) {
      startSteps = currentSteps;
    }

    activitySteps.value = currentSteps - startSteps;

    calculateDistance();
    calculateCalories();
  }

  void calculateDistance() {
    activityDistance.value = (activitySteps.value * 0.762) / 1000;
  }

  void calculateCalories() {
    activityCalories.value = activitySteps.value * 0.04;
  }

  void onRecognitionError(error) {
    debugPrint("Activity Pedometer Error: $error");
  }

  Future<void> finishActivity() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Update Workouts Count
    final workout = prefs.getInt(Keys.totalWorkouts) ?? 0;
    await prefs.setInt(Keys.totalWorkouts, workout + 1);

    // 2. Update Total Calories
    final totalCalories = prefs.getDouble(Keys.totalCalories) ?? 0.0;
    await prefs.setDouble(
        Keys.totalCalories, totalCalories + activityCalories.value);

    // 3. Update Total Distance
    final totalDistance = prefs.getDouble(Keys.totalDistance) ?? 0.0;
    await prefs.setDouble(
        Keys.totalDistance, totalDistance + activityDistance.value);

    // 4. Notify HistoryController to refresh its data if it's currently active
    if (Get.isRegistered<HistoryController>()) {
      Get.find<HistoryController>().loadHistoryData();
    }

    activityTimer?.cancel();
    await stepStreams?.cancel();
    stepStreams = null;
    startActivityTimer.value = false;
    remainingSeconds.value = 0;
    startSteps = 0;

    update();
  }
}
