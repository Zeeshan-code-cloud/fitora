 import 'package:fitoraa/features/botton_nav_bar/bottom_nav_bar_controller.dart';
import 'package:fitoraa/features/export.dart';

import '../water_reminder_screen/set_water_reminder_controller.dart';

class BottomNavBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(BottomNavBarController());
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ActivityController(), fenix: true);
    Get.lazyPut(() => HistoryController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SetWaterReminderController(), fenix: true);
  }
}