import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'home_controller.dart';

class HomeBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> HomeController() ,fenix: true);
  }

}