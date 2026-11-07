import 'dart:io';
import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/core/storage/notification_services/notification_services.dart';
import 'package:fitoraa/core/theme/theme_controller.dart';
import 'package:fitoraa/features/auths_screens/data/user_model.dart';
import 'package:fitoraa/features/auths_screens/presentations/controller/auth_controller.dart';
import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/water_reminder_screen/set_water_reminder_controller.dart';
import 'package:fitoraa/widgets/app_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_permission/smart_permission.dart';
import 'package:url_launcher/url_launcher.dart';

  class ProfileController extends GetxController {

    late final SetWaterReminderController waterReminderC;
    final themeC = Get.find<ThemeController>();

    late UserModel user;
    final authC = Get.find<AuthController>();
    RxBool toggledNotification = true.obs;
    RxBool lightTheme = false.obs;
    ImagePicker? imagePicker;
    RxString totalWorkouts = "0".obs;
    Rxn<File> file = Rxn<File>();
    RxString profileImage = "".obs;

    @override
    void onInit() async {
      super.onInit();
      if (Get.isRegistered<SetWaterReminderController>()) {
        waterReminderC = Get.find<SetWaterReminderController>();
      } else {
        waterReminderC = Get.put(SetWaterReminderController());
      }
      user = authC.currentUser.value!;
      await loadProfileImage();
      await loadNotificationState();
    }

    @override
    void onReady() async {
      super.onReady();
      final prefs = await SharedPreferences.getInstance();
      totalWorkouts.value = prefs.getString(Keys.totalWorkouts) ?? "0";
      await loadNotificationState();
    }

    Future<void> loadNotificationState() async {
      final prefs = await SharedPreferences.getInstance();
      toggledNotification.value =
          prefs.getBool(Keys.waterReminderEnabled) ?? true;
    }


    Future<String> saveImagePermanently(String imagePath) async {
      final directory = await getApplicationDocumentsDirectory();

      final fileName = imagePath.split("/").last;
      final savedImage =  await File(imagePath).copy('${directory.path}/$fileName');
      final prefs = await SharedPreferences.getInstance();
        prefs.setString(Keys.profileImagePath, savedImage.path);
        await loadProfileImage();
      return savedImage.path;
    }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath =  prefs.getString(Keys.profileImagePath);
    profileImage.value = imagePath ?? "";
  }

   Future<void> selectImageFromGallery() async {
    final result = await SmartPermission.requestResult(
      permission: Permission.photos,
      title: "Permission Required",
      description: "To select images from gallery.",
    );

    if (result.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (!result.isGranted) {
      return;
    }

    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image != null) {
      await saveImagePermanently(image.path);

    }
  }

  Future<void> toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      bool hasPermission = await NotificationServices.requestPermission();
      if (hasPermission) {
        toggledNotification.value = true;
        await prefs.setBool(Keys.waterReminderEnabled, true);
        await waterReminderC.toggleReminder(true);
      } else {
        toggledNotification.value = false;
        await prefs.setBool(Keys.waterReminderEnabled, false);
        AppSnackbar.show(
          title: "Permission Required",
          message: "Please allow notification permission to receive notifications.",
        );
      }
    } else {
      toggledNotification.value = false;
      await prefs.setBool(Keys.waterReminderEnabled, false);
      await waterReminderC.toggleReminder(false);
      await NotificationServices.cancelAll();
    }
  }


  Future<void> launchToWeb(String url) async {
      Uri uri = Uri.parse(url);
      if(!await launchUrl(
          uri,
          mode: LaunchMode.externalApplication
      )){
        Get.snackbar("launch error", "url are invalid");
      }
  }

    Future<void> launchPlayStore(String packageName) async {
    final Uri uri = Uri.parse(
      "https://play.google.com/store/apps/details?id=$packageName",
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Get.snackbar(
        "Error",
        "Could not open Play Store",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Future<void> toggleReminder(bool value) async {
    waterReminderC.reminderEnabled.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Keys.waterReminderEnabled, value);

    if (value) {
       await waterReminderC.scheduleAllWaterReminders();
    } else {
      await waterReminderC.cancelAllWaterReminders();
    }
  }

}

