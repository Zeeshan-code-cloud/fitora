import 'package:fitoraa/features/export.dart';
import 'package:fitoraa/features/setting_screens/setting_controller.dart';

class SettingBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SettingController(), fenix: true);
  }

}