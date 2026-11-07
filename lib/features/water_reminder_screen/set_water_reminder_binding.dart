import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/water_reminder_screen/set_water_reminder_controller.dart';

class SetWaterReminderBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SetWaterReminderController());
  }

}