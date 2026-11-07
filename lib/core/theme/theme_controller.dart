import 'package:fitoraa/core/storage/keys/keys.dart';
import 'package:fitoraa/features/export.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController  extends GetxController{
  RxBool isDarkMode = false.obs;

  @override
  void onInit() async {
    super.onInit();
   await  loadTheme();
  }


Future<void>  loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
   isDarkMode.value =  prefs.getBool(Keys.themeKeys) ?? true; 
   Get.changeThemeMode(
     isDarkMode.value ? ThemeMode.dark : ThemeMode.light
   );
  }

  Future<void> toggledTheme() async {
  isDarkMode.value = !isDarkMode.value;

  final prefs = await SharedPreferences.getInstance();
  await  prefs.setBool(Keys.themeKeys, isDarkMode.value);
  Get.changeThemeMode(
    isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
  );
  }
}