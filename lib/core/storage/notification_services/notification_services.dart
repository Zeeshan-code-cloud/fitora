import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/features/home_screen/home_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;


@pragma('vm:entry-point')
Future<void> notificationTapBackground(
    NotificationResponse response) async {

  if (response.actionId == 'drink_water') {
    final prefs = await SharedPreferences.getInstance();

    final current =
        prefs.getDouble(Keys.currentLiter) ?? 0.0;

    final intake =
        prefs.getDouble(Keys.waterPerReminder) ?? 0.25;

    await prefs.setDouble(
      Keys.currentLiter,
      current + intake,
    );
  }
}

class NotificationServices {


  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSetting = AndroidInitializationSettings("@mipmap/ic_launcher");
    const setting = InitializationSettings(android: androidSetting);
    await notificationsPlugin.initialize(
      settings: setting,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }




  static Future<void> _onNotificationResponse(
      NotificationResponse response) async {

    if (response.actionId == 'drink_water') {

      final prefs = await SharedPreferences.getInstance();

      final current =
          prefs.getDouble(Keys.currentLiter) ?? 0.0;

      final intake =
          prefs.getDouble(Keys.waterPerReminder) ?? 0.25;

      await prefs.setDouble(
        Keys.currentLiter,
        current + intake,
      );

      if (Get.isRegistered<HomeController>()) {
        final homeC = Get.find<HomeController>();
        await homeC.loadWaterData();
      }
    }
  }

  static Future<bool> requestPermission() async {
    final anroidImple = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final grant = await anroidImple?.requestNotificationsPermission() ?? false;
    return grant;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          "fitora_channel",
          "Fitora Notifications",
          importance: Importance.max,
          priority: Priority.high,
          icon: "notification_icon",
        ),
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration duration,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(duration),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          "water_channel",
          "Water Reminder",
          importance: Importance.max,
          priority: Priority.max,
          icon: "notification_icon",
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> scheduleDailyTimeNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          "water_channel",
          "Water Reminder",
          channelDescription: "Daily hydration reminders between 8 AM and 10 PM",
          importance: Importance.max,
          priority: Priority.max,
          icon: "notification_icon",
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'drink_water',
              'I Drank It',
            ),
          ],
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id: id);
  }

  static Future<void> cancelNotificationRange(int startId, int count) async {
    for (int i = 0; i < count; i++) {
      await notificationsPlugin.cancel(id: startId + i);
    }
  }

  static Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
  }
}
