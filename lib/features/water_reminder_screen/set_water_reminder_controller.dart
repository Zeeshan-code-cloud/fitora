
import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/core/storage/notification_services/notification_services.dart';
import 'package:fitoraa/features/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SetWaterReminderController extends GetxController {
  late final HomeController homeC  ;

  static const int startHour = 8; // 8:00 AM
  static const int endHour = 22; // 10:00 PM (14 active hours total)
  static const int baseNotificationId = 200;
  static const int maxSlots = 50;

  RxBool reminderEnabled = true.obs;
  RxInt selectedIntervalMinutes = 120.obs;
  int? _firstReminderMinute;

  final List<Map<String, dynamic>> intervals = [
    {
      'label': '30 Minutes',
      'subtitle': 'Remind every 30 minutes',
      'minutes': 30,
    },
    {
      'label': '1 Hour',
      'subtitle': 'Remind every 1 hour',
      'minutes': 60,
    },
    {
      'label': '2 Hours',
      'subtitle': 'Remind every 2 hours',
      'minutes': 120,
    },
    {
      'label': '3 Hours',
      'subtitle': 'Remind every 3 hours',
      'minutes': 180,
    },
  ];


  final List<int> waterGoalOptions = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  String get selectedIntervalText {
    switch (selectedIntervalMinutes.value) {
      case 30:
        return "30 minutes";
      case 60:
        return "1 hour";
      case 120:
        return "2 hours";
      case 180:
        return "3 hours";
      default:
        return "${selectedIntervalMinutes.value} minutes";
    }
  }

  /// Calculates daily reminder slots from the configured reminder start time.
  ///
  /// The first reminder is always one selected interval after the user enables
  /// or changes the reminder, rather than snapping to a fixed 8 AM schedule.
  List<TimeOfDay> get activeTimeSlots {
    final slots = <TimeOfDay>[];
    final int startMinutes = startHour * 60; // 08:00 (480 mins)
    final int endMinutes = endHour * 60; // 22:00 (1320 mins)
    final int step = selectedIntervalMinutes.value;
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final firstReminderMinute = _firstReminderMinute ??
        _nextReminderMinute(
          nowMinutes: nowMinutes,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          intervalMinutes: step,
        );

    for (int m = firstReminderMinute; m <= endMinutes; m += step) {
      slots.add(TimeOfDay(hour: m ~/ 60, minute: m % 60));
    }
    return slots;
  }

  int _nextReminderMinute({
    required int nowMinutes,
    required int startMinutes,
    required int endMinutes,
    required int intervalMinutes,
  }) {
    final firstToday = nowMinutes + intervalMinutes;
    if (firstToday >= startMinutes && firstToday <= endMinutes) {
      return firstToday;
    }

    // When configured outside the active window, resume at the next day's
    // opening time instead of scheduling an immediate reminder.
    return startMinutes;
  }

  int get totalRemindersCount => activeTimeSlots.length;

  int get goalLiters => homeC.totalWalterLiter.value;

  int get goalMl => goalLiters * 1000;

  /// Target water intake per notification in ml
  int get intakePerReminderMl {
    if (totalRemindersCount == 0) return 250;
    return (goalMl / totalRemindersCount).round();
  }

  /// Target intake in standard glasses (1 glass = 250 ml)
  double get intakePerReminderGlasses {
    return (intakePerReminderMl / 250.0);
  }

  String get intakePerReminderFormatted {
    if (intakePerReminderMl >= 1000) {
      return "${(intakePerReminderMl / 1000).toStringAsFixed(2)} L";
    }
    return "$intakePerReminderMl ml";
  }

  String get glassesFormatted {
    final g = intakePerReminderGlasses;
    return "${g.toStringAsFixed(1)} glass${g == 1.0 ? '' : 'es'}";
  }

  @override
  void onInit() {
    super.onInit();
    homeC = Get.find<HomeController>();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    reminderEnabled.value = prefs.getBool(Keys.waterReminderEnabled) ?? true;
    selectedIntervalMinutes.value =
        prefs.getInt(Keys.waterReminderInterval) ?? 120;
    _firstReminderMinute = prefs.getInt(Keys.waterReminderStartMinute);
    if (reminderEnabled.value) {
      _firstReminderMinute ??= await _saveFirstReminderMinute();
      await scheduleAllWaterReminders();
    }
  }

  Future<void> toggleReminder(bool value) async {
    reminderEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Keys.waterReminderEnabled, value);

    if (value) {
      _firstReminderMinute = await _saveFirstReminderMinute();
      await scheduleAllWaterReminders();
    } else {
      await cancelAllWaterReminders();
    }
  }

  Future<void> setInterval(int minutes) async {
    selectedIntervalMinutes.value = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Keys.waterReminderInterval, minutes);
    _firstReminderMinute = await _saveFirstReminderMinute();

    if (reminderEnabled.value) {
      await scheduleAllWaterReminders();
    }
  }

  Future<void> setWaterGoal(int liters) async {
    await homeC.setWaterGoal(liters);
    if (reminderEnabled.value) {
      await scheduleAllWaterReminders();
    }
  }

  Future<void> rescheduleWaterReminders() async {
    if (reminderEnabled.value) {
      await scheduleAllWaterReminders();
    }
  }

  Future<int> _saveFirstReminderMinute() async {
    final now = TimeOfDay.now();
    final firstReminderMinute = _nextReminderMinute(
      nowMinutes: now.hour * 60 + now.minute,
      startMinutes: startHour * 60,
      endMinutes: endHour * 60,
      intervalMinutes: selectedIntervalMinutes.value,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(Keys.waterReminderStartMinute, firstReminderMinute);
    return firstReminderMinute;
  }

  /// Schedules daily notifications across the 14 active hours (8 AM to 10 PM)
  Future<void> scheduleAllWaterReminders() async {
    // 1. Cancel previous slots first
    await cancelAllWaterReminders();

    if (!reminderEnabled.value) return;

    // 2. Request permission if not already granted
    final hasPermission = await NotificationServices.requestPermission();
    if (!hasPermission) return;

    final slots = activeTimeSlots;
    final intakeMl = intakePerReminderMl;
    final intakeText = intakePerReminderFormatted;
    final glassesText = glassesFormatted;
    final currentGoal = goalLiters;

    // 3. Schedule recurring daily notification for each active slot
    for (int i = 0; i < slots.length; i++) {
      final slot = slots[i];
      final timeFormatted = _formatTimeOfDay(slot);
      final id = baseNotificationId + i;

      final title = "Hydration Break ($timeFormatted) 💧";
      final body = "Drink $intakeText (~$glassesText) now to reach your daily ${currentGoal}L goal!";

      await NotificationServices.scheduleDailyTimeNotification(
        id: id,
        title: title,
        body: body,
        hour: slot.hour,
        minute: slot.minute,
      );
      final prefs = await SharedPreferences.getInstance();

      await prefs.setDouble(
        Keys.waterPerReminder,
        intakePerReminderMl / 1000,
      );
    }
  }

  Future<void> cancelAllWaterReminders() async {
    await NotificationServices.cancelNotificationRange(
      baseNotificationId,
      maxSlots,
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  void showGoalPicker() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Pill Indicator
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
          
              /// Title
              AppText(
                "Daily Water Goal",
                type: AppTextType.heading3,
                color: AppColors.textPrimary,
              ),
              SizedBox(height: 0.5.h),
              AppText(
                "Select your daily water target to customize your reminders.",
                type: AppTextType.captionDark,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 2.5.h),
          
              /// Goal Options
              ...waterGoalOptions.map((goal) {
                return Obx(() {
                  final bool isSelected = homeC.totalWalterLiter.value == goal;
          
                  return GestureDetector(
                    onTap: () {
                      setWaterGoal(goal);
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 1.5.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondaryCyan.withOpacity(0.12)
                            : AppColors.glassDarkLarge,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondaryCyan
                              : AppColors.glassBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.secondaryCyan.withOpacity(0.2)
                                  : AppColors.glassDark,
                            ),
                            child: Icon(
                              Icons.water_drop_rounded,
                              color: isSelected
                                  ? AppColors.secondaryCyan
                                  : AppColors.textSecondary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 3.5.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "$goal Liters (${goal * 1000} ml)",
                                  type: AppTextType.bodyBold,
                                  color: isSelected
                                      ? AppColors.secondaryCyan
                                      : AppColors.textPrimary,
                                ),
                                SizedBox(height: 0.3.h),
                                AppText(
                                  "~${goal * 4} glasses per day",
                                  type: AppTextType.captionDark,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.secondaryCyan,
                              size: 22.sp,
                            ),
                        ],
                      ),
                    ),
                  );
                });
              }),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showIntervalPicker() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Pill Indicator
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            /// Title
            AppText(
              "Reminder Interval",
              type: AppTextType.heading3,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: 0.5.h),
            AppText(
              "Reminders run during 14 active hours (8:00 AM – 10:00 PM).",
              type: AppTextType.captionDark,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 2.5.h),

            /// Interval Options List
            ...intervals.map((interval) {
              final int minutes = interval['minutes'] as int;
              final String label = interval['label'] as String;
              final int slotsCount = (14 * 60) ~/ minutes + 1;
              final int calculatedMl = (goalMl / slotsCount).round();

              return Obx(() {
                final bool isSelected =
                    selectedIntervalMinutes.value == minutes;

                return GestureDetector(
                  onTap: () {
                    setInterval(minutes);
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1.5.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondaryCyan.withOpacity(0.12)
                          : AppColors.glassDarkLarge,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondaryCyan
                            : AppColors.glassBorderDark,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.secondaryCyan.withOpacity(0.2)
                                : AppColors.glassDark,
                          ),
                          child: Icon(
                            Icons.timer_outlined,
                            color: isSelected
                                ? AppColors.secondaryCyan
                                : AppColors.textSecondary,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 3.5.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                label,
                                type: AppTextType.bodyBold,
                                color: isSelected
                                    ? AppColors.secondaryCyan
                                    : AppColors.textPrimary,
                              ),
                              SizedBox(height: 0.3.h),
                              AppText(
                                "$slotsCount reminders • ~$calculatedMl ml each",
                                type: AppTextType.captionDark,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.secondaryCyan,
                            size: 22.sp,
                          ),
                      ],
                    ),
                  ),
                );
              });
            }),
            SizedBox(height: 1.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
