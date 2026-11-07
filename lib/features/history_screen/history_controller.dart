import 'dart:async';
import 'package:fitoraa/core/storage/lacal_db/step_history_model.dart';
import 'package:fitoraa/core/storage/lacal_db/step_history_service.dart';
import 'package:fitoraa/features/history_screen/step_summary.dart';
import 'package:fitoraa/features/home_screen/home_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/storage/keys/keys.dart';
import '../../enums.dart';

class HistoryController extends GetxController {
  RxInt totalWorkouts = 0.obs;
  RxDouble calories = 0.0.obs;
  RxInt steps = 0.obs;
  RxDouble distance = 0.0.obs;
  RxBool showHistoryDate = false.obs;
  Rx<HistoryFilter> selectedFilter = HistoryFilter.thisWeek.obs;

  StreamSubscription? _hiveSubscription;

  @override
  void onInit() {
    super.onInit();
    setFilter(selectedFilter.value);

    // Reactively refresh when Hive box updates
    if (Hive.isBoxOpen('step_history')) {
      _hiveSubscription =
          Hive.box<StepHistoryModel>('step_history').watch().listen((_) {
        setFilter(selectedFilter.value);
      });
    }

    // Reactively refresh when live steps change in HomeController
    if (Get.isRegistered<HomeController>()) {
      final homeC = Get.find<HomeController>();
      ever(homeC.currentSteps, (_) {
        setFilter(selectedFilter.value);
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadHistoryData();
    setFilter(selectedFilter.value);
  }

  @override
  void onClose() {
    _hiveSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    totalWorkouts.value = prefs.getInt(Keys.totalWorkouts) ?? 0;
  }

  void setFilter(HistoryFilter filter) {
    selectedFilter.value = filter;
    switch (filter) {
      case HistoryFilter.thisWeek:
        loadPeriods(days: 7);
        break;
      case HistoryFilter.lastWeek:
        loadPeriods(days: 14);
        break;
      case HistoryFilter.thisMonth:
        loadPeriods(days: 30);
        break;
    }
  }

  List<StepHistoryModel> getHistory({required int days}) {
    final box = Hive.isBoxOpen('step_history')
        ? StepHistoryService.userHistory
        : null;
    final now = DateTime.now();
    final List<StepHistoryModel> list = [];

    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";
      final altKey =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final item = box?.get(key) ?? box?.get(altKey);

      int daySteps = item?.steps ?? 0;
      double dayCalories = item?.calories ?? 0.0;
      double dayDistance = item?.distance ?? 0.0;
      int dayActiveMinutes = item?.activeMinutes ?? 0;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        if (Get.isRegistered<HomeController>()) {
          final homeC = Get.find<HomeController>();
          final liveSteps = homeC.currentSteps.value;
          if (liveSteps > daySteps) {
            daySteps = liveSteps;
            dayCalories = homeC.callories.value;
            dayDistance = homeC.currentDistance.value;
            dayActiveMinutes = homeC.activeTime.value;
          }
        }
      }

      list.add(
        StepHistoryModel(
          date: key,
          steps: daySteps,
          calories: dayCalories,
          distance: dayDistance,
          activeMinutes: dayActiveMinutes,
        ),
      );
    }

    return list;
  }

  List<FlSpot> getChartSpots({required int days}) {
    final history = getHistory(days: days);

    return List.generate(history.length, (index) {
      return FlSpot(
        index.toDouble(),
        history[index].steps.toDouble(),
      );
    });
  }

  double getMaxY({required int days}) {
    final history = getHistory(days: days);

    if (history.isEmpty) return 1000;

    final maxSteps = history
        .map((e) => e.steps.toDouble())
        .reduce((a, b) => a > b ? a : b);

    return maxSteps == 0 ? 1000 : maxSteps * 1.2;
  }

  String getBottomLabel(int index, int days) {
    final date = DateTime.now().subtract(
      Duration(days: days - 1 - index),
    );

    return "${date.day}";
  }

  StepSummary getSummary({required int days}) {
    final history = getHistory(days: days);
    int totalSteps = 0;
    double totalDistance = 0.0;
    double totalCalories = 0.0;
    int totalActiveMinutes = 0;

    for (final item in history) {
      totalSteps += item.steps;
      totalDistance += item.distance;
      totalCalories += item.calories;
      totalActiveMinutes += item.activeMinutes;
    }

    return StepSummary(
      totalSteps: totalSteps,
      totalDistance: totalDistance,
      totalCalories: totalCalories,
      totalActiveMinutes: totalActiveMinutes,
    );
  }

  void loadPeriods({required int days}) {
    final summary = getSummary(days: days);
    steps.value = summary.totalSteps;
    distance.value = summary.totalDistance;
    calories.value = summary.totalCalories;
  }
}
