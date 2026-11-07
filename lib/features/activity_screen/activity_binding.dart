import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import 'activity_controller.dart';

class ActivityBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ActivityController(), fenix: true);
  }

  }

