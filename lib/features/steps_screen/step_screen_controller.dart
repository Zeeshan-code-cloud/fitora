import 'dart:async';
import 'package:fitoraa/features/export.dart';
import 'package:hive/hive.dart';

import '../../core/storage/lacal_db/step_history_model.dart';


class StepScreenController extends GetxController {
  final homeC = Get.find<HomeController>();

  RxInt barChartIndex = 1.obs; // 1 = Week, 2 = Month

  RxList<int> weeklySteps = <int>[].obs;
  RxList<String> weeklyDays = <String>[].obs;
  RxList<int> monthlySteps = <int>[].obs;
  RxDouble percentChangeFromYesterday = 0.0.obs;
  RxInt currentSteps = 0.obs;

  StreamSubscription? _hiveSubscription;

  @override
  void onInit() {
    super.onInit();
    loadData();

    // Reactively refresh chart data whenever current steps or goal change
    ever(homeC.currentSteps, (_) => loadData());
    ever(homeC.totalSteps, (_) => update());

    // Listen directly to any changes in the Hive box
    if (Hive.isBoxOpen('step_history')) {
      _hiveSubscription =
          Hive.box<StepHistoryModel>('step_history').watch().listen((_) {
        loadData();
      });
    }
  }

  @override
  void onClose() {
    _hiveSubscription?.cancel();
    super.onClose();
  }

  void loadData() {
    currentSteps.value = homeC.currentSteps.value;
    weeklySteps.value = getWeeklyData();
    weeklyDays.value = getWeeklyDayLabels();
    monthlySteps.value = getMonthlySteps();
    percentChangeFromYesterday.value = getYesterdayPercentageChange();
  }

  List<int> getWeeklyData() {
    final box = Hive.isBoxOpen('step_history')
        ? Hive.box<StepHistoryModel>('step_history')
        : null;
    final now = DateTime.now();

    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final key = "${date.year}-${date.month}-${date.day}";

      final item = box?.get(key);
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        final liveSteps = homeC.currentSteps.value;
        return (item != null && item.steps > liveSteps)
            ? item.steps
            : liveSteps;
      }

      return item?.steps ?? 0;
    });
  }

  List<String> getWeeklyDayLabels() {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return weekDays[date.weekday - 1];
    });
  }

  List<int> getMonthlySteps() {
    final box = Hive.isBoxOpen('step_history')
        ? Hive.box<StepHistoryModel>('step_history')
        : null;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return List.generate(daysInMonth, (index) {
      final date = DateTime(now.year, now.month, index + 1);
      final key = "${date.year}-${date.month}-${date.day}";

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        final item = box?.get(key);
        final liveSteps = homeC.currentSteps.value;
        return (item != null && item.steps > liveSteps)
            ? item.steps
            : liveSteps;
      }

      if (date.isAfter(now)) {
        return 0;
      }

      final item = box?.get(key);
      return item?.steps ?? 0;
    });
  }

  double getYesterdayPercentageChange() {
    final box = Hive.isBoxOpen('step_history')
        ? Hive.box<StepHistoryModel>('step_history')
        : null;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final key = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
    final item = box?.get(key);
    final yesterdaySteps = item?.steps ?? 0;

    final todaySteps = homeC.currentSteps.value;
    if (yesterdaySteps <= 0) {
      return todaySteps > 0 ? 100.0 : 0.0;
    }
    return (((todaySteps - yesterdaySteps) / yesterdaySteps) * 100);
  }
}
